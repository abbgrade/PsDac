using Microsoft.SqlServer.Dac;
using Azure.Core;
using Azure.Identity;
using System.Threading;

namespace PsDac
{
    internal class AzureAuthProvider : IUniversalAuthProvider
    {
        private readonly DefaultAzureCredential credential = new DefaultAzureCredential();
        private readonly TokenRequestContext tokenRequestContext;

        public string Resource { get; private set; }

        public AzureAuthProvider (string resource)
        {
            Resource = resource;
            tokenRequestContext = new TokenRequestContext(new[] { Resource.TrimEnd('/') + "/.default" });
        }

        public string GetValidAccessToken()
        {
            return credential.GetToken(tokenRequestContext, CancellationToken.None).Token;
        }
    }
}
