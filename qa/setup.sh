#!/bin/sh

sh ./vendor/pheromone/phpcs-security-audit/symlink.sh

cp ./git/hook.pre-commit ../.git/hooks/pre-commit
chmod +x ../.git/hooks/pre-commit
