# serein functions that extend build/envsetup.sh

function serein_device_combos()
{
    local T list_file variant device

    T="$(gettop)"
    list_file="${T}/vendor/serein/serein.devices"
    variant1="userdebug"
    variant2="user"

    if [[ $1 ]]
    then
        if [[ $2 ]]
        then
            list_file="$1"
            variant="$2"
        else
            if [[ ${VARIANT_CHOICES[@]} =~ (^| )$1($| ) ]]
            then
                variant="$1"
            else
                list_file="$1"
            fi
        fi
    fi

    if [[ ! -f "${list_file}" ]]
    then
        echo "unable to find device list: ${list_file}"
        list_file="${T}/vendor/serein/serein.devices"
        echo "defaulting device list file to: ${list_file}"
    fi

    while IFS= read -r device
    do
        add_lunch_combo "serein_${device}-${variant1}"
        add_lunch_combo "serein_${device}-${variant2}"
    done < "${list_file}"
}

function serein_rename_function()
{
    eval "original_serein_$(declare -f ${1})"
}

function _serein_build_hmm() #hidden
{
    printf "%-8s %s" "${1}:" "${2}"
}

function serein_append_hmm()
{
    HMM_DESCRIPTIVE=("${HMM_DESCRIPTIVE[@]}" "$(_serein_build_hmm "$1" "$2")")
}

function serein_add_hmm_entry()
{
    for c in ${!HMM_DESCRIPTIVE[*]}
    do
        if [[ "${1}" == $(echo "${HMM_DESCRIPTIVE[$c]}" | cut -f1 -d":") ]]
        then
            HMM_DESCRIPTIVE[${c}]="$(_serein_build_hmm "$1" "$2")"
            return
        fi
    done
    serein_append_hmm "$1" "$2"
}

function sereinremote()
{
    local proj pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm serein 2> /dev/null

    proj="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"

    if (echo "$proj" | egrep -q 'external|system|build|bionic|art|libcore|prebuilt|dalvik') ; then
        pfx="android_"
    fi

    project="${proj//\//_}"

    git remote add serein "git@github.com:Serein-OS/$pfx$project"
    echo "Remote 'serein' created"
}

function cmremote()
{
    local proj pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm cm 2> /dev/null

    proj="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    pfx="android_"
    project="${proj//\//_}"
    git remote add cm "git@github.com:CyanogenMod/$pfx$project"
    echo "Remote 'cm' created"
}

function aospremote()
{
    local pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm aosp 2> /dev/null

    project="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    if [[ "$project" != device* ]]
    then
        pfx="platform/"
    fi
    git remote add aosp "https://android.googlesource.com/$pfx$project"
    echo "Remote 'aosp' created"
}

function cafremote()
{
    local pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
    fi
    git remote rm caf 2> /dev/null

    project="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    if [[ "$project" != device* ]]
    then
        pfx="platform/"
    fi
    git remote add caf "git://codeaurora.org/$pfx$project"
    echo "Remote 'caf' created"
}

function serein_push()
{
    local branch ssh_name path_opt proj
    branch="lp5.1"
    ssh_name="serein_review"
    path_opt=

    if [[ "$1" ]]
    then
        proj="$ANDROID_BUILD_TOP/$(echo "$1" | sed "s#$ANDROID_BUILD_TOP/##g")"
        path_opt="--git-dir=$(printf "%q/.git" "${proj}")"
    else
        proj="$(pwd -P)"
    fi
    proj="$(echo "$proj" | sed "s#$ANDROID_BUILD_TOP/##g")"
    proj="$(echo "$proj" | sed 's#/$##')"
    proj="${proj//\//_}"

    if (echo "$proj" | egrep -q 'external|system|build|bionic|art|libcore|prebuilt|dalvik') ; then
        proj="android_$proj"
    fi

    git $path_opt push "ssh://${ssh_name}/Serein-OS/$proj" "HEAD:refs/for/$branch"
}


serein_rename_function hmm
function hmm() #hidden
{
    local i T
    T="$(gettop)"
    original_serein_hmm
    echo

    echo "vendor/serein extended functions. The complete list is:"
    for i in $(grep -P '^function .*$' "$T/vendor/serein/build/envsetup.sh" | grep -v "#hidden" | sed 's/function \([a-z_]*\).*/\1/' | sort | uniq); do
        echo "$i"
    done |column
}

serein_append_hmm "sereinremote" "Add a git remote for matching serein repository"
serein_append_hmm "aospremote" "Add git remote for matching AOSP repository"
serein_append_hmm "cafremote" "Add git remote for matching CodeAurora repository."
