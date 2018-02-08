if [ "$TRAVIS_BRANCH" != "master" ]; then 
    exit 0;
fi

mix hex.user auth <<EOF
ramondelemos
${HEX_KEY}


EOF

mix hex.publish <<EOF
y

EOF