using Azure.Core;
using Azure.Identity;
using Microsoft.SqlServer.Dac;

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
            return new DefaultAzureCredential().GetToken(
                new TokenRequestContext(scopes: new string[] { Resource + "/.default" }) { }
            ).Token;
        }
    }
}
