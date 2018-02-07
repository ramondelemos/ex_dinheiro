if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

## Setup hex user
mkdir -p ~/.hex
echo '{username,<<"'ramondelemos'">>}.' > ~/.hex/hex.config
echo '{key,<<"'${HEX_KEY}'">>}.' >> ~/.hex/hex.config

## Add the rebar3 hex plugin to global
mkdir -p ~/.config/rebar3
echo '{plugins, [rebar3_hex]}.' > ~/.config/rebar3/rebar.config

./rebar3 hex publish <<EOF
y
EOF