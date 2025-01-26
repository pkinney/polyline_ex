[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Styler],
  input_deps: [:stream_data]
]
