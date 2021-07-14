FROM elixir:latest

# Create and set home directory
WORKDIR /app

# Configure required environment
ENV MIX_ENV prod

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all dependencies files
COPY mix.*  ./

# Install all production dependencies
RUN mix deps.get

# Compile all dependencies
RUN mix deps.compile

# Copy all application files
COPY . .

# Compile the entire project
RUN mix compile

CMD ["./bin/start.sh"]
