use Mix.Config

config :sesame, Sesame,
  secret_key: "correct-battery-horse-staple",
  serializer: Sesame.TestSesameSerializer,
  policy: Sesame.TestSesamePolicy
