#!/bin/bash

# This function checks if the image is backed up by us through checking its pattern
function image_backedup_by_us() {
  date_str="$1"
  pattern="[0-9]{4}[0-9]{2}[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}"
  if [[ $date_str =~ $pattern ]]; then
    echo 1
  else
    echo 0
  fi
}


function del_old_backup_through_commit(){

    for line in $(docker image ls | awk '{print $1":"$2}')
    do
        img=$(echo $line)
        img_tag=$(echo $img | awk -F ":" '{print $2}')

        # calculates the number of seconds elapsed since the epoch for the specific image.
        sec_number=$(date -d "$(echo $img | awk -F ":" '{print $2}'| tr '_' ' '| tr '-' ':')" \
          +%s 2> /dev/null )

        # If the image has our backup signature (specified on image tag), it will be further processed
        # so we prevent unwanted changes to non backed up original images
        if [[ ! -z "$sec_number" ]] && [[ $(image_backedup_by_us $img_tag) -eq 1 ]] ; then
            #Calculates the number of seconds passed since the creation of the backup image (date specified on it's tag).
            sec_number=$(( $(date +%s) - $sec_number))

            #number of seconds in 3 hours
            three_hours=10800

            # Deletes backed up images older than 3 hours
            if [[ $sec_number -ge $three_hours ]]; then
                docker rmi $img
                echo "image $img was deleted"
            fi
        fi

    done
}


function backup_through_commit(){

    del_old_backup_through_commit
    for line in $(docker ps | awk '{print $NF}')
    do
        container_id=$(echo $line | tr -d ':')
        image_version=$(date +%Y%m%d_%H-%M-%S)
        docker commit $line $container_id:$image_version
    done
}

function backup_through_tarfile(){

    find ./saved_images -type f -mmin +600 -delete

    for line in $(docker image ls | awk '{print $1":"$2}')
    do
        img=$(echo $line)
        img_tag=$(echo $img | awk -F ":" '{print $2}')

        # Only backup images created by us using docker commit
        if [[ $(image_backedup_by_us $img_tag) -eq 1 ]] ; then

            img2=$(echo $img |tr ':' '-')

            if [[ $(ls ./saved_images |grep $img2| wc -l) -eq 0 ]]; then
                echo $img
                docker save $img > ./saved_images/$img2.tar
            fi
        fi
    done


}

backup_through_commit
backup_through_tarfile
