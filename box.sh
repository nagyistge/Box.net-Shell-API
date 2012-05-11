BASEDIR="`dirname $0`"
. $BASEDIR/config.sh
. $BASEDIR/function.sh

if [ "$1" == "" ];
then
        usage
        exit 1
fi

check_api

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
				if [ "$1" != "" ];
				then
                                	filename=$1
				else
					echo -e "\nError, no file specified for uploading, use -f filename\n"
					exit 1
				fi
                                ;;
        -a | --auth )		auth=1
                                ;;
	-l | --list )		shift
				folder_id=$1
				list_folder=1
				;;
	-u | --upload )		upload_file=1
				;;
        -h | --help )           usage
                                exit
                                ;;
	--force )		force=1
				;;
	-d | --directory )	shift
				if [ "$1" != "" ];
				then
					folder_id=$1
				else
					folder_id=0
				fi
				;;
	-s | --silent )		silent=1
				;;
        * )                     usage
                               	exit 1
    esac
    shift
done
if [ "$auth" == "1" ];
then
	if [ "$TOKEN" != "" ];
        then
		if [ "$force" == "1" ];
		then
			echo -e "\nForcing new authentification."
			get_ticket
			display_auth_url
			get_token
			update_conf
			echo -e "\nDone, check config.sh\n"
			exit 0
		else
        		echo -e "\nError, already authorized. Use --force to force new auth.\n"
                	exit 1
		fi
        fi
	echo -e "\nAuthentification started ...\n"
        get_ticket
        display_auth_url
        get_token
        update_conf
        echo -e "Done, check config.sh\n"
fi

if [ "$list_folder" == "1" ];
then
	if [ "$folder_id" == "" ];
	then
		folder_id=0
		echo -e "\nNo folder ID specified, listing root folder :\n"
		get_list
		echo ""
		exit 0
	else
		if [ "$silent" != 1 ];
		then
			echo -e "\nListing folder with ID $folder_id :\n"
		fi
		get_list
		echo ""
		exit 0
	fi
	exit 0
fi

if [ "$upload_file" == "1" ];
then
	if [ "$filename" != "" ];
	then
		if [ "$folder_id" == "" ];
		then
			folder_id=0
			echo -e "\nNo folder ID specified, choosing root folder for uploading file $filename.\n"
			upload
			echo ""
			exit 0
		else
			echo -e "\nUploading file $filename to folder ID $folder_id.\n"
			upload
			echo ""
			exit 0
		fi
	else
		echo -e "\nError, no file specified. Use -f filename to specify the file to upload.\n"
	fi
fi