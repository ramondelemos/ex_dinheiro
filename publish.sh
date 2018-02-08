if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

echo '{username,<<"'ramondelemos'">>}.' > hex.config
echo '{key,<<"'${HEX_KEY}'">>}.' >> hex.config

#mkdir -p ~/.config/rebar3
#echo '{plugins, [rebar3_hex]}.' > ~/.config/rebar3/rebar.config

mix hex.publish <<EOF
y
EOF