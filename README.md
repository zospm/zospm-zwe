# zospm-zwe
This readme describes how to use this package to install and configure Zowe using zospm.
You will need to install and configure zospm, along with Z Open Automation Utilities first before you can install Zowe. 
See the zospm readme for details on installing and configure zospm.


# Get Zowe:
- If you do not know the name of the Zowe package, you can find it using search:
 - zospm search zowe
  - This should print out: ZWE1B0 5698-ZWE IBM Z Distribution for Zowe
  - If you get an error that it can't find properties, verify you copied your properties to the right spot and that you set ZOSPM_WORKROOT to point to your work directory
- The first field of the search output is the name of the software package - in this case zwe1b0.
 zospm knows how to install and configure Zowe Version 1.11.0 (B is 11 in hexadecimal), i.e. zwe1b0
- By default, software installation packages will be installed where zospm is installed 
 (in our example in $ZOSPM_ROOT/../).
 If you want to change this location, export ZOSPM_REPOROOT to specify a different directory

- Refresh the Zowe package:
 - zospm refresh zwe
 - This will download the Zowe zospm installation package into $ZOSPM_ROOT/../zospm-zwe, e.g. /usr/lpp/zospm-zwe
  - unless you set ZOSPM_REPOROOT, in which case it will install it into $ZOSPM_REPOROOT/zospm-zwe
  
- Set configuration variables for Zowe:
 - This is similar to how you configured zospm. You need to tell zospm how you want to 
  install and configure Zowe.
 
 - There are two sample properties files you can use: 
   - zwe1b0props_ADCDV24.json or zwe1b0props_template.json
   - Choose the ADCD sample if you are using an IBM ADCD system, otherwise choose the template
   - Copy the file into your work directory, e.g.
    - cp $ZOSPM_ROOT/../zospm-zwe/zwe1b0/zwe1b0props_ADCDV24.json $ZOSPM_WORKROOT/props/zwe1b0props.json
   - Edit the Zowe properties file to match your system
    - See: ... for a description of the properties  
    
Configure zospm for Zowe:
 - In the order directory, you need to tell zospm where it should find Zowe
  - Create $ZOSPM_ROOT/order/zwe1b0order.json with the following contents:
  ```
  {
 	"software": [{
		"relid":"ZWE1B0",
		"order":{
                        "SMPE_DELIVERY":"PPA"
                 }
	}]
  }
  ```
  - This order information tells zospm that installation is like IBM Passport Advantage - it will look 
   for a pax.Z file locally
 - In the pkg directory, upload the Zowe pax file to $ZOSPM_WORKROOT/pkg/ZWE1B0.pax.Z

# Install Zowe:

- zospm install zwe1b0
- This will do a number of things under the covers. See: for a deep dive.
- Assuming all goes well, you can now proceed to configure Zowe.
- If you want to configure on the same system as you installed on, you can proceed directly to the configure step
- If you want to configure Zowe on a different system:
 - perform a binary copy of $ZOSPM_TMP/zwe1b0.dzp to your target system
  - You can find the value of ZOSPM_TMP in your $ZOSPM_WORKROOT/props/zospmglobalprops.json file - it defaults to /tmp
 - configure zospm as described above on the target system
 - ensure you put zwe1b0.dzp in the corresponding ZOSPM_TMP directory on your target system

# Configure Zowe:
- On your target system (which may be the same as your installation system):
- zospm configure zwe1b0

This will create a set of scripts in your $ZOSPM_WORKROOT/config/zwe1b0 directory
- Inspect these scripts if you want. These scripts will perform your system-specific configuration
- You can either run the scripts one at a time manually, or you can say:
 - zospmrunsteps config zwe1b0
 - which will run each step in turn, stopping if any step fails
 
Zowe should now be installed and configured on your system.
Note that some configuration items will not persist after you IPL. 
The updates required for your system that you need to apply for persistence can be found in:
- ZOSPMT.PROCLIB
- ZOSPMT.PARMLIB
and should be incorporated into your system as per your company policies

To remove Zowe from the target system:
- zospm deconfigure zwe1b0
- zospmrunsteps deconfig zwe1b0

To uninstall Zowe from the source system:
- zospm uninstall zwe1b0

