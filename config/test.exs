use Mix.Config

config :sesame, Sesame,
  secret_key: "correct-horse-battery-staple",
  serializer: Sesame.TestSesameSerializer,
  policy: Sesame.TestSesamePolicy
