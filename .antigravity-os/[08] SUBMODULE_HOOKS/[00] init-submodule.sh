#!/bin/bash
git submodule add https://github.com/svw10/antigravity-os.git .antigravity-os
git submodule update --init --recursive
echo "✅ Integrado. Nunca edite .antigravity-os/ diretamente!"