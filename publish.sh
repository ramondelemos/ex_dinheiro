if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

mix hex.config username ramondelemos
mix hex.config key $HEX_KEY
mix hex.publish <<EOF
y
EOF