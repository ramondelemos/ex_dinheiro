if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

mkdir -p ~/.hex
echo '{username,<<"'ramondelemos'">>}.' > ~/.hex/hex.config
echo '{key,<<"'${HEX_KEY}'">>}.' >> ~/.hex/hex.config

mix hex.publish <<EOF
y
EOF