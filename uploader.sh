#!/bin/bash
# github util
# author: hyongbai

gh_repo=resources
gh_host=https://api.github.com
gh_owner=hyongbai
#
gh_user=hyongbai
gh_emial=hyongbai+github@gmail.com

# upload file to github
# for more information: <https://developer.github.com/v3/repos/contents>
gh_up(){
    local f=${1} && [ ! -f $f ] && return 1
    local folder=${2}
    local sha=`sha1sum ${f}`
    local name=`__sh_file_name ${f}`
    local content=`base64 < ${f}`
    local _path=${name} && [ ${folder} ] && _path=${folder}/${_path}
    local url=${gh_host}/repos/${gh_owner}/${gh_repo}/contents/${_path}

    echo "Uploading..."
    # request, using CURL_DATA fix: argument list too long
    local result=$(curl -kis -X PUT "$url" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -d @- \
<< CURL_DATA
        {
          "message": "#upload# ${name}",
          "committer": {
            "name": "${gh_user}",
            "email": "${gh_emial}"
          },
          "content": "${content}", 
          "sha": "${sha}"
        }
CURL_DATA
)

local img=`echo $result | grep download_url | awk -F\" '{print $4}'`

[ ${img} ] && echo "Result:     ![$name]($img)" || echo result

}