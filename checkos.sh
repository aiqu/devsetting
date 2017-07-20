CURRENT_OS="OSX" #CENTOS, UBUNUTU are other valid options
function findCurrentOSType()
{
    echo "Finding the current os type"
    echo
    osType=$(uname)
    case "$osType" in
            "Darwin")
            {
                echo "Running on Mac OSX."
                CURRENT_OS="OSX"
            } ;;    
            "Linux")
            {
                # If available, use LSB to identify distribution
                if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
                    DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
                else
                    DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
                fi
                CURRENT_OS=$(echo $DISTRO | tr 'a-z' 'A-Z')
            } ;;
            *) 
            {
                echo "Unsupported OS, exiting"
                exit
            } ;;
    esac
}

findCurrentOSType
echo $CURRENT_OS
