#!/bin/bash
set -eou pipefail

SCRIPT_ROOT=$(realpath $(dirname "${BASH_SOURCE[0]}"))
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

K8S_VERSION=v1.18.3

GITHUB_USER=${GITHUB_USER:-1gtm}
PR_BRANCH=gomod-refresher-$(date +%s)
COMMIT_MSG="Update to Kubernetes $K8S_VERSION"

refresh() {
    echo "refreshing repository: $1"
    pushd /tmp
    rm -rf repo
    git clone --no-tags --no-recurse-submodules --depth=1 https://${GITHUB_USER}:${GITHUB_TOKEN}@$1.git repo
    cd repo
    git checkout -b $PR_BRANCH
    gomod-gen --desired-gomod="$SCRIPT_ROOT/$K8S_VERSION/go.mod"
    go mod tidy
    go mod vendor
    [ -z $2 ] || eval $2
    git add --all
    if git diff-index --quiet HEAD --; then
        echo "Repository $1 is up-to-date."
        return 0
    fi
    git commit -a -s -m "$COMMIT_MSG"
    # git push origin $PR_BRANCH -f
    hub pull-request \
        --push \
        --labels automerge \
        --message "$COMMIT_MSG" \
        --message "Signed-off-by: $(git config --get user.name) <$(git config --get user.email)>"
    # gh pr create \
    #     --base master \
    #     --fill \
    #     --label automerge \
    #     --reviewer tamalsaha
    popd
}

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Correct usage: $SCRIPT_NAME <path_to_repos_list>"
    exit 1
fi

if [ -x $GITHUB_TOKEN ]; then
    echo "Missing env variable GITHUB_TOKEN"
    exit 1
fi

while IFS=, read -r repo cmd; do
    if [ -z "$repo" ]; then
        continue
    fi
    refresh "$repo" "$cmd"
done <$1
