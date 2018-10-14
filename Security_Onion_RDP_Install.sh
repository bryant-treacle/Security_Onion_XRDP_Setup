#!/bin/bash
# Author: Bryant Treacle
# DateL 2018.10.14

#Install Necessary Deb Packages for XRDP
sudo dpkg -i libtasn1-bin_4.10-1.1+deb9u1_amd64.deb
sudo dpkg -i libtasn1-3-bin_4.10-1.1+deb9u1_all.deb
sudo dpkg -i tigervncserver_1.7.0-1ubuntu1_amd64.deb

# Verify the user account that vncserver will display.  
echo ""
echo "Is $USER the user account you want vncserver to connect to?  (y/n)"
read verifyuser

if [ ${verifyuser,,} = "y" ] ; then
    vncserver

else
    echo ""
    echo "What user account do you want vncserver to connect to?"
    read vncuseraccount
	
	if id "$vncuseraccount" >/dev/null 2>&1; then
	    if [ ! -d "/home/$vncuseraccount" ] ; then
	        echo ""
		echo "It appears $vncuseraccount does not have a home directly.  Vncserver must create a ~/.vnc directory for the user account.  Would you like to create a home directory for $vncuseraccount? (y/n)"
	        read userhomecreate
		    if [ ${userhomecreate,,} = "y" ] ; then
			sudo mkhomedir_helper $vncuseraccount
			sudo -H -u $vncuseraccount bash -c 'vncserver'
		    else 
			echo ""
			echo "starting vncserver with $USER"
			vncserver
		    fi
	    else 
                sudo -H -u $vncuseraccount bash -c 'vncserver'
	    fi

	else
	    echo "It appears $vncuseraccount does not exist.  Would you like to create $vncuseraccount?  (y/n)"
	    read vncnewuser
		if [ ${vncnewuser,,} = "y" ] ; then 
		    echo ""
		    echo "Enter the new username"
		    read vncnewusername
		    sudo adduser $vncnewusername
		    sudo -H -u $vncuseraccount bash -c 'vncserver'
		else 
                    echo "starting vncserver with $USER"
                    vncserver
		fi
	fi 
			
fi

sudo dpkg -i xrdp_0.6.1-2_amd64.deb

#Configure xrdp to use High Security encryption
sudo service xrdp stop
sudo sed -i 's/crypt_level=low/crypt_level=high/g' /etc/xrdp/xrdp.ini
sudo service xrdp start

#Prompt user to add ufw firewall rule
echo ""
echo "Would you like to add ufw firewall rule to allow rdp traffic? (y/n)"
read UFW_RULE

if [ ${UFW_RULE,,} = "y" ] ; then

    echo "Enter the IP address or subnet you want to allow through the firewall."
    echo "examples- IP Address: 192.168.1.23  Subnet: 192.168.1.0/24"
    
    read IP_ADDRESS
	sudo ufw allow from $IP_ADDRESS to any port 3389

else
    exit

fi
echo ""
echo "Finished!!!"
