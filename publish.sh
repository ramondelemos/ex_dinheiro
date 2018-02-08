if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

mkdir -p ~/.hex
echo '{username,<<"'ramondelemos'">>}.' > ~/.hex/hex.config
echo '{key,<<"'${HEX_KEY}'">>}.' >> ~/.hex/hex.config

#mkdir -p ~/.config/rebar3
#echo '{plugins, [rebar3_hex]}.' > ~/.config/rebar3/rebar.config

rebar3 hex publish <<EOF
y
EOF