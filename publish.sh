if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

echo '{username,<<"'ramondelemos'">>}.' > hex.config
echo '{key,<<"'${HEX_KEY}'">>}.' >> hex.config

mix hex.publish <<EOF
y
EOF