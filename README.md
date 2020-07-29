# zospm-zwe
This readme describes how to use this package to install and configure Zowe using zospm.
You will need to install and configure zospm, along with Z Open Automation Utilities first before you can install Zowe. 
See the zospm readme for details on installing and configure zospm.


# Get Zowe:
- If you do not know the name of the Zowe package, you can find it using search:
 - zospm search zowe
  - This should print out: _ZWE1B0 5698-ZWE IBM Z Distribution for Zowe_
  - If you get an error that it can't find properties, verify you copied your properties to the right spot and that you set ZOSPM_WORKROOT to point to your work directory
- The first field of the search output is the name of the software package - in this case _zwe1b0_.
 zospm knows how to install and configure Zowe Version 1.11.0 (B is 11 in hexadecimal), i.e. _zwe1b0_
- By default, software installation packages will be installed in the same directory as zospm. For our example, assume zospm is installed at _/usr/lpp/zospm_

- Refresh the Zowe package:
 - _zospm refresh zwe_
 - This will download the Zowe zospm installation package (at _/usr/lpp/zospm-zwe_ since _zospm) is installed at _/usr/lpp/zospm_)
  
- Set configuration variables for Zowe:
 - This is similar to how you configured zospm. You need to tell zospm how you want to 
  install and configure Zowe.
 
 - There are two sample property template files you can use: 
   - _zwe1b0props\_ADCDV24.json_ or _zwe1b0props\_template.json_
   - Choose the ADCD sample if you are using an IBM ADCD system, otherwise choose the template sample
   - Copy the file into your work directory, e.g.
    - cp _/usr/lpp/zospm-zwe/zwe1b0/zwe1b0props\_ADCDV24.json $ZOSPM\_WORKROOT/props/zwe1b0props.json_
   - Edit the Zowe properties file to match your system
    - See: ... for a description of the properties \[tbd\]
    
Configure zospm for Zowe:
 - In the order directory, you need to tell zospm where it should find Zowe
  - Create $ZOSPM_ROOT/order/zwe1b0order.json with the following contents:
  ```
  {
 	"software": [{
		"relid":"ZWE1B0",
		"order":{
                        "SMPE_DELIVERY":"LOCAL"
                 }
	}]
  }
  ```
  - This order file tells zospm that the pax.Z file should be found locally. 
 - In the pkg directory, upload the Zowe pax file to _$ZOSPM\_WORKROOT/pkg/ZWE1B0.pax.Z_

# Install Zowe:

- _zospm install zwe1b0_
- This will do a number of things under the covers. See: https://makingdeveloperslivesbetter.wordpress.com/2020/03/25/drinking-deep-with-zbrew/ for a deep dive.
- Assuming all goes well, you can now proceed to configure Zowe.
- If you want to configure on the same system as you installed on, you can proceed directly to the configure step
- If you want to configure Zowe on a different system:
 - perform a binary copy of _$ZOSPM\_TMP/zwe1b0.dzp_ to your target system
  - You can find the value of _ZOSPM\_TMP_ in your \$ZOSPM\_WORKROOT/props/zospmglobalprops.json_ file - it defaults to _/tmp_
 - configure zospm as described above on the target system
 - ensure you put _zwe1b0.dzp_ in the corresponding _ZOSPM\_TMP_ directory on your target system

# Configure Zowe:
- On your target system (which may be the same as your installation system):
- _zospm configure zwe1b0_

This will create a set of scripts in your _$ZOSPM\_WORKROOT/config/zwe1b0_ directory
- Inspect these scripts if you want. These scripts will perform your system-specific configuration
- You can either run the scripts one at a time manually, or you can say:
 - _zospmrunsteps config zwe1b0_
 - which will run each step in turn, stopping if any step fails
 
Zowe should now be installed and configured on your system.
Note that some configuration items will not persist after you IPL. 
The updates required for your system that you need to apply for persistence can be found in:
- _ZOSPMT.PROCLIB_
- _ZOSPMT.PARMLIB_
and should be incorporated into your system as per your company policies

To remove Zowe from the target system:
- _zospmrunsteps deconfig zwe1b0_
- _zospm deconfigure zwe1b0_

To uninstall Zowe from the source system:
- _zospm uninstall zwe1b0_

