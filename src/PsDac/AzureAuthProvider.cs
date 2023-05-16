using Microsoft.SqlServer.Dac;
using Microsoft.Azure.Services.AppAuthentication;

namespace PsDac
{
    internal class AzureAuthProvider : IUniversalAuthProvider
    {
        public string Resource { get; private set; }

        public AzureAuthProvider (string resource)
        {
            Resource = resource;
        }

        public string GetValidAccessToken()
        {
            return new AzureServiceTokenProvider().GetAccessTokenAsync(resource: Resource).Result;
        }
    }
}
