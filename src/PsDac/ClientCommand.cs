using Microsoft.SqlServer.Dac;
using System;
using System.Collections.Concurrent;
using System.Management.Automation;
using System.Threading;

namespace PsDac
{
    public abstract class ClientCommand : PSCmdlet
    {

        [Parameter()]
        public DacServices Service { get; set; } = ConnectServiceCommand.Service;

        private ConcurrentQueue<Object> OutputMessageQueue { get; set; } = new ConcurrentQueue<Object>();


        protected override abstract void BeginProcessing();

        protected void BeginProcessing(bool serviceRequired)
        {
            base.BeginProcessing();

            if (Service == null)
            {
                if (serviceRequired == true)
                    throw new PSArgumentNullException(nameof(Service), $"run Connect-DacService");
            }
            else
            {
                Service.Message += Service_Message;
            }
        }

        protected sealed override void ProcessRecord()
        {
            base.ProcessRecord();

            var thread = new Thread(AsyncProcessRecordWithoutException);
            thread.Start();

            // process message events while running
            while (thread.ThreadState == ThreadState.Running)
            {
                OutputMessageQueue.TryDequeue(out var record);
                if (record != null)
                {
                    ProcessOutputMessage(record);
                }
                else
                {
                    Thread.Sleep(100);
                }
            }

            thread.Join();

            // process remaining message events after termination
            while (!OutputMessageQueue.IsEmpty)
            {
                OutputMessageQueue.TryDequeue(out var record);
                if (record != null)
                {
                    ProcessOutputMessage(record);
                }
            }
        }

        private void ProcessOutputMessage(object message)
        {
            switch (message)
            {
                case OutputRecord outputRecord:
                    base.WriteObject(sendToPipeline: outputRecord.SendToPipeline); break;
                case VerboseRecord verboseMessage:
                    base.WriteVerbose(verboseMessage.Text); break;
                case WarningRecord warningMessage:
                    base.WriteWarning(warningMessage.Text); break;
                case ErrorRecord errorRecord:
                    base.WriteError(errorRecord); break;
                default:
                    throw new NotSupportedException($"{message.GetType()} is not supported.");
            }
        }

        protected abstract void AsyncProcessRecord();

        private void AsyncProcessRecordWithoutException()
        {
            try
            {
                AsyncProcessRecord();
            }
            catch (Exception ex)
            {
                WriteError(new ErrorRecord(ex, null, ErrorCategory.NotSpecified, null));
            }
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();

            if (Service != null)
                Service.Message -= Service_Message;
        }

        private void Service_Message(object sender, DacMessageEventArgs e)
        {
            switch (e.Message.MessageType)
            {
                case DacMessageType.Message:
                    ProcessServiceMessage(e);
                    break;
                case DacMessageType.Warning:
                    ProcessServiceWarning(e);
                    break;
                case DacMessageType.Error:
                    ProcessServiceError(e);
                    break;
                default:
                    throw new NotSupportedException($"{e.Message.MessageType} is not supported.");
            }
        }

        #region Error

        private void ProcessServiceError(DacMessageEventArgs e)
        {
            WriteError(new ErrorRecord(
                exception: new Exception($"{e.Message}"),
                errorId: e.Message.Number.ToString(),
                errorCategory: ErrorCategory.NotSpecified,
                targetObject: null
            ));
        }

        new protected void WriteError(ErrorRecord errorRecord)
        {
            OutputMessageQueue.Enqueue(errorRecord);
        }

        #endregion
        #region Warning

        private void ProcessServiceWarning(DacMessageEventArgs e)
        {
            WriteWarning($"SQL{e.Message.Number}: {e.Message.Message}");
        }

        new protected void WriteWarning(string text)
        {
            OutputMessageQueue.Enqueue(new WarningRecord(text));
        }
        private record WarningRecord(string Text);

        #endregion
        #region Verbose

        private void ProcessServiceMessage(DacMessageEventArgs e)
        {
            switch (e.Message.Number)
            {
                case 0:
                    WriteVerbose($"{e.Message.Message}");
                    break;
                default:
                    WriteVerbose($"SQL{e.Message.Number}: {e.Message.Message}");
                    break;
            }
        }

        new protected void WriteVerbose(string text)
        {
            OutputMessageQueue.Enqueue(new VerboseRecord(text));
        }

        private record VerboseRecord(string Text);

        #endregion
        #region Output

        new protected void WriteObject(object sendToPipeline)
        {
            OutputMessageQueue.Enqueue(new OutputRecord(sendToPipeline));
        }

        private record OutputRecord(object SendToPipeline);

        #endregion
    }
}
