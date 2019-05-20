defmodule DebugGuardian.SecretFetcher do
  use Guardian.Token.Jwt.SecretFetcher

  def fetch_signing_secret(_module, _opts) do
    secret =
      "rsa-2048.pem"
      |> fetch()

    {:ok, secret}
  end

  def fetch_verifying_secret(_module, _headers, _opts) do
    secret =
      "rsa-2048.pub"
      |> fetch()

    {:ok, secret}
  end

  defp fetch(relative_path) do
    :code.priv_dir(:debug_guardian)
    |> Path.join(relative_path)
    |> JOSE.JWK.from_pem_file()
  end
end
