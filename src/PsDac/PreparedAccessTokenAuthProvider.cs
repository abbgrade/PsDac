using Microsoft.SqlServer.Dac;

namespace PsDac
{
    internal record class PreparedAccessTokenAuthProvider(string Token) : IUniversalAuthProvider
    {
        public string GetValidAccessToken() => Token;
    }
}
