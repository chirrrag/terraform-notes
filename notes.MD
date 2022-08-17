TF stores the state of infra that is being created from TF files into .tfstate file...
This state allows terraform to map real world resource to our existing configuration.
# note:- donot touch tfstate file...
# always store the backup of tfstate file


# desired State:-
Terraform's primary function is to create,modify, and destroy infra resources to match the desired state described in Terraform configuration.

resource "aws_instance" "my-ec2" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

# this is desired state of terraform Aws instance

# current state:-
it is actual state of resource that is currently deployed.
i.e. instance abhi t2 medium pe runn kr rha hai vo humara currentstate hain,but new configruation file me humne t2.micro chlana hai vo humari desired state hain

# IMPORTANT:-
terraform tries to ensure that the deployed infra is based on desisred state.
If there is a difference between the 2, terraform plan presents the description of changes necessary to acheive desired state.
Terraform always tries to achieve the desired state.

terraform humesha desired state me jane ki koshish karta hain, ie specified in terraform fie. so humesha detail me type kro jo bhi resource tum create kr rhe ho.,
for instance, attach custom security group to instance from console, and then type "terraform refresh". than tfstate file me refresh hojaega humaraa security group to custom

> provider plugins are released differently from Terraform

in provider tab
provider {
    version = "~>"
}
there are various signs which are important to know

# version arguments               Description
1. >=1.0                          Greater than equal toversion.
2. <= 1.0                         Less than equal to version.
3. ~>2.0                          any version in the 2.X range.
4. >=2.10,<=2.30                   any version between 2.10 & 2.30


Donot user ~> this versioning in productin environment

NOTE:- when we do terraform init, not only the providers file, but also a lock.hcl file is also downloaded. which helps us in various things
suppose we use ~>3.0 than use terraform init
lock file me 3.x version download hojaega and than hum agar version change krkre 2.0 krdte hain and firse init karege toh err throw krega!!!
Lock file helps to stick to a specific version to specific constraint...

now to download 2.x version, we have to remove the lock file
for reference
> 02

now, if you have to change version based on your requirement
use 
> terraform init -upgrade
command

<!-- OUTPUT AND ATTRIBUTED -->
output = 
resource_name.local_resource_name # this is the resource block

output "mys3bucket" {
  value = resource_name.local_resource_name
}

in terraform registry, there is a option of attribute reference, 
int that attribute reefrence, we have all the attributes which we can print.

we can print all the attributes associated with EIB
just use the terraform apply command, there will be also the dedicated section of output in tfstate file!!!!!!!!!!
for refernece:- section 2:- attributes.tf


attributes are basically the value blocks associated with a specific property of a resource.
ouput are used for outputting the specific attributes

ingress is basically:- inbound
egress:- outbound

for .10 version :- add "${}"
for .11 version onwards add :- [] or we can directly add the variables


<!-- VARIABLES -->
in terminal
we can change the varibale values as:-
terraform plan -var="instance_type=t2.micro"

# NOTE:-  always store value of variables in terraform.tfvars
##### #############################################
suppose we have different variable values for production and development environment
and prod env vars are stored in prod.tfvars
 than if we want to use it, we have to explictly tell the terraform to use tprod.tfvars file:-
> terraform plan -var-file="prod.tfvars"

##### #################################3
Environment variable based approach for setting variable
Windows specific command:- 
> setx TF_VAR_<variable> <value>
> setx TF_VAR_instance_type m5.large

LINUX BASED COMMAND:- 
$ export TF_VAR_instance_type="t2.nano"
echo $TF_VAR_instance_type

<!-- Data type for variables -->
we can also define the data type of variable in terraform.!!!!
data type can be number, string, list , map
> string "hello"
> number "234"
> list ["hey", "yoyu" ,"how you doin?"]
> map Example:200


<!-- ---------------------------------------------------------------

 -->
 # COUNT PARAMETERS
 the count parameter on resource can simplify configuration and let you scale resource by simply incrementing number.
 example:- create 2 same ec2 instance
 in resources
 just type count = 5 to create 5 ec2 instances

 resource "" "" {
  count = 5
 }
 #### count.index
 the distinct number(starting with 0) corresponding to this instance

 suppose there are 5 loadbalancers. count.index will name them 0 to 4 in the end, but they can also help in naming them as 
 dev-loadbalancer, prod-loadbalancer, etc,etc

 <!-- Conditional Expression -->
 They use value of bool expression to select one of 2 values.
 Syntax:- 
 > condition? true_val : false_val
 for conditinal expression, we have to create the variable
 and in resource block, we have to use count variable
 i.e.
 count = var.istest == true ? 1 : 0
 <!-- Local Values -->
 locals {
  common_tags = {
    Owner = "Devops Team"
    service = "backend"
  }
 }

 to use them
 tags = local.common_tags
 # Definition
 A local value assigns a name to an expression, allowing it to be used multiple times within a module without replacing it.
 ############## local value support for expression
 local values can also be used for conditional expression.
 locals {
  name_prefix = "${var.name != ""  ? var.name  : var.default}"
 }

 # Functions
 > syntax
 function_namae(args1, args2)
 example 
 max(5,12,9)
 Terraform doesnot support userdefined functions~!!
 only built in function are available for use
 numeric, string, colection, encoding, filesystem, Date and time, Hash and crypto, Ip network, type conversion

 use 
 terraform console command in terminal to use terraform functions

 > terraform console

 lookup(map, key, default)
 ecample:-
 lookup({a="ay", b="bee"}, "a", "what?")
 o.p ;- ay
 lookup({a="ay", b="bee"}, "c", "what?")
 o.p ;- what

 element function:-
 element(var.tags, count.index)
 element(list, index)
  element retreives teh single element from the list

  file("{path.module}/id_rsa.pub")
  timestamp() will show us the current timestamp
  formatdate(spec, timestamp) function can convert the timestamp to specofoc formatt.

  formatdate("DD MM YY hh:mm ZZZ", timestamp())


<!-- DATASOURCES -->

Data source allow data to be fetched or computed for elsewhere in terraform configuration files.
data source will compoute the ami id of particular region based on given parameters.
Data Source:-
  1. is defined under the data block
  2. Reads from a specific data block(aws_ami) and exports result under app_ami

<!-- Debbuging in Terraform -->
Terraform has detailed logs which can be enabled by ssetting the TF_LOG environment variable to any value.
you can set  TF_LOG   to one of the loglevels TRACE , DDEBUG, INFO, WARN, or ERROR  to change the verbosity of logs.

> in terminal, type "export TF_LOG=TRACE" to get thedetailed TRACED output

or to get it in the file> type":-

export TF_LOG_PATH=/tmp/terraform/terraform-crash.log

to STOP THE DEBUGGING
unset the TF_LOG environment variable by typing
<!-- unset TF_LOG command -->

# the terraform fmt   command  is used to rewrit terraform configuration files to take care of overall formatting.

<!-- Validating the terraform configuration files -->
use command "terraform validate"
###### #######################################3
<!-- LOAD ORDER AND SEMANTICS -->
terraform generally load all the configuration files within the directory specified in alphabetically order.
the file loaded must end in either .tf  or .tf.json to specify the format that is in use.

we should not have multiple same resource with same local name


###### ###############################3
<!-- dynamic blocks in terraform -->

it allows us to dynamically construct repeatable nested blocks which is supported inside resource, data, provider and provisioner blocks.
iterator in dynamic block:_
the iterator argument(optional) set the name of a temporary variable that represents the current element of complex value.
if omitted, the name of variable defaults tothe label  of dynamic block.


###### #######################################
<!-- Terraform Taint -->
this command manually marks the terraform-managed resources as tainted, forcing it to be destroyed and recreated on next apply!!!

> terraform taint aws_instance.myec2
we have to specify the resource
than we can also see that the status of that particualar resource is Tainted in .tfstate file


###### #################################################3
<!-- SPLAT EXPRESSIONS -->

Splat expression allows us to get the list of all attrributes.
lb[*] is splat expression
instead of *, we can also add number instead of *

##### #####################################################
<!-- TERRAFORM GRAPH -->
teraform graph command, is used to generate visual represntation of either a configuration or execution plan.
output of terraform graph is in DOT format, which can easily be converted to an image.
> terraform graph > graph.dot
use graphviz file to see the graph.dot file in graph visualization format!!!
> winget install graphviz || to install graphviz in windows
> choco install graphviz || to install graphviz in windows

now, to convert graph.dot file to visualization graph, type command
cat graph.dot | dot -Tsvg > graph.svg

now open it in chrome

##### #################################
<!-- SAVING TERRAFORM PLAN TO FILE -->

the generated terraform plan can be saved to a specific path
this plan can than be used with terraform apply to be certain that only the changes, shown in path are applied1!
> terraform plan -out=path

plan changes from changing configuration, so to get previous configuration we can save our plan. 

to run apply on plan file use
> terraform plan <demopath>

##### #########################################
<!-- TERRAFORM OUTPUT -->
this command is used to extract the value of an output variable from the state file.

>  terraform output iam_names

##### #########################################
<!-- TERRAFORM SETTINGS -->

terraform settings are gathered togetherr in terraform settings
i.e. 
special terraform configuration block is used to configure some behavioours of terraform itslef, such as requiring minimum terraform version to apply your configuration.
> terraform {
  # ...
  required_version = ">0.12.0"
  required_providers {
    mycloud = {
      source = ""
      version = "~>"
    }
  }
}

##### #########################################

<!-- CHALLANGES WITH LARGER INFRASTRUCTURE -->

we will face issue related to API limits from provider in case of larger infra.
we can prevent terraform from querying the current state DURING oprerations like terraform plan.
this can be acheieved with the -refresh=false flag

-target=resource flag can be used to target a specific resource.
generally used as a means to operate on isolated portions of very large configration.
> terraform plan -target=ec2

terraform plan always refresh the pages, it will slow down the infra and will increase the API calls 
so use 
> terraform plan -refresh=false
and in terraform plan, andd apply command, in terminal "~" represents :- update is in place.
we can update specificc thing:0
> terrafom plan -target=resourcename.localname

##### ##########################################
<!-- ZIPMAP FUNCTIONS -->

zipmap function constructs a map from a list of keys and corresponding list of values.
zipmap(keylist, valuelist)
> zipmap([1,2],[3,4])
{
  "1" = 3
  "2" = 4
}

<!-- TERRAFORM COMMENTS -->
# :- single line
// :- single line
/*  <content> */ :- multiline


###### ##############################################################3

<!-- /PROVISIONERS -->
Provisioners make terraform a great tool in respect of other IAC tools.

after creation of EC2 instance, some application/webservers get installed on them, this can be done with the help of Provisioners.
Provisioners are used to execute scripts on a local or remote machine as part of resource  creation or destruction.
ecxample:- on creation of instance, install nginx webserver on it.!!!

provisioners work under the resoruce block

resource "" "" {
  provisioner "type" {

  }
}

<!-- TYPES OF PROVISIONERS -->
main 2 types of provisioners:-
1. local-exec :- this allows us to invoke local executable after resource is created. this will execute anything locally!!!
example :-
> resource "" "" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.private_ip} >> private_ip.txt"
  }
}
this command will run on terraform terminal and will write the private ip address of that instance to private_ip.txt file!!!
2. remote-exec :- they allow us to invoke scripts directly on the remote server!!!
provisioner "remote-exec" {

}

Tf has capability to turn provisioners both at time of resource creation as well as destruction.


<!-- REMOTE-EXEC -->
it invokes a script on a remote resource after the it is created! 
ex:- installing a software on ec2 instance

chmod 400 terraform-key.pem
ssh -i terraform-key.pem ec2-user@<public_ip>

The self Object

Expressions in connection blocks cannot refer to their parent resource by name. References create dependencies, and referring to a resource by name within its own block would create a dependency cycle. Instead, expressions can use the self object, which represents the connection's parent resource and has all of that resource's attributes. For example, use self.public_ip to reference an aws_instance's public_ip attribute.


<!-- LOCAL PROVISIONER -->
it allows us to invoke a local executable after the resource is created!!!
one of the most used approach of local exec is to run ansible playbook on the created server after the resource is created!!!


<!-- CREATION AND DESTROY TIME PROVISIONERS -->
creation time provisioners are only runs during creation , not during updating or any other lifecycle.
if a creation time provisioner fails, the resource is marked as tainted...

destroy provisioners are run before the resource is destroyed!!!

> provisioner "local-exec" {
  when = destroy
  command = "echo 'destroy it' "
}

if when=destroy is specified , the provisoner will run when the resource is definedwithin its destroyed

<!-- FAILURE BEHAVIOUR IN PROVISIONER -->
by default, provisioner that fail will also cause the terraform apply itself to fail!
the on_failure setting can be used to change this:-
on_failure = continue | ignore the err and continue with creation or destructino!!!
on_failure= fail || raise an err and stop applying (the default behaviour), if this is a creation provisioner, taint the resource!!

<!-- NULL RESOURCE -->
the null resouce implements the standadrd resource lifecycle but takes no further action!!

triggers = {

}
triggers are a map of arbitary strings  that when changed , will force the null resource to be replaced, re running any assocaited provisioner.

##### MODULES
modules are nothing but centralised source where the code is defined and the resource block is defined somewhere else, we import the resource block into some other file and those resource blocks are used in terraform tf files individually


CHALLANGES WITH MODULES:-
one common need on infra management is to build multiple environment like staging, production with similar setup but keeping env variable different
example
Staging:- instance_type = t2.micro
Production:- instance_type = x5.large

if we hard code the modules in module directory, we will not be able to overwrite it in destination.
instead of hardcoding the value, we can make use of variables!!

instance_type = "t2.micro"
will be changed to 
instance_type = var.instance_type

NOTE:- using variables in modules, can also allow users to override the value which you might not want..
there can be many repitive values in modules, and this makes our code difficult  to maintain., we can centralize these variables, but users will be able to override it

<!-- USING LOCALS WITH MODULES -->

instead of variables, wre can make use of locals to assgin the values because by centralize them via variables user will be able to overwrite it, but not in case od using locals.

locals {
  app_port=8443
}

for using it:-
local.app_port

<!-- REFERENCING MODULE OUTPUTS -->
output value makes information about your infra available on command line and can expose info for other terraform configu to use.
in parent module, output of child modules are available in expresssion as module.
module.<modulename>.<outputname>


omce we defined the ouput at module level, that output will not be part of CLI. to make it part of CLI, we have to define that ouput again in Project level
ouput "name" {
  value = "module.<moidulename>.<output name>
}
######
<!-- TERRAFORM REGISTRY -->
tf registry is repo of modules written by tf community.

we can also launch ec2 instance with the help of veriried module, directly.

<!-- PUBLISHING MODULES TO RTERRAFORM REGISTRY -->
anyone can publish and share modules on terraform registry
published modules supports versioniong, automatically generate documenteation, allow browsing version histores, show examples and READMEs and more.

requirement for publishing modules.
1. github :- modules must be on github and must be a public repo. .this is only requirement for public registry.
2. named:-  module repo must use this 3 part name format terraform
terraform-<PROVIDER>-<NAME>
3. repo desciption:- github repo is used to populate the short description of module.
4. standard module structure:- module must adhere to standard module structure/
5. xyz for releases:-  the registy uses tags to identify version. release name must be a semantic tag version , which can be optionally be fixed with v, v1.0.4

standard module structure is a file and directory layout that is recommended for reusable modules distributed in seeparate repo.

#####
<!-- TERRAFORM WORKSPACE -->
tf allows us to have multiple workspace, with each of the workspace we have, we can have different set of environment variable associated.

commands 
> terraform workspace
> terraform workspace show :- will show us the current workspace
> terraform workspace list : -will list all the workspace
> terraform workspace select dev :- will select the dev workspace


default workspace :- t2.nano
dev:- t2.micro
prod :- m3.large


> terraform workspace -h :- will list all thecommands
> terraform workspace new dev :- will create new workspace named dev, and will switch to it
> terraform workspace new prod 

we have to use map as well as function
variable "instance_type" {
  type = "map"
  default = {
    default = "t2.nan0"
    dev = "t2.micro"
    prod = "m5.large"
  }
}


DEPENDING UPON instance_type we can change the terraform workspace

after apply, it will make a folder named "terraform.tfstate.d"
this folder have 2 environment dev and prod




NOTE:- never store passwod or API keys in to git repo


##### ################################################3
MODULE SOURCES IN TERRAFORM
the source argument in module  tells where to find source code for desired child module.
1. local paths, terraform regsitry, github, bitbucket, generic git, mercurial repos,  https url, s3 bucket, gcs bucket.

git module source can be used by prefixing the address with speical "git::" perfix in source

<!-- ?- -->BACKENDS
backend primarly determines where the terraform store its state
terraform primarily uses a backend called local to store state as localfile on disk(tfstate file).
tf file should be stored in central repo
and tfstate file should be stored in central backend.
Terraform supports multiple backends:- S3, consul, azurerm, kubernetes, httpd, etcd

key is the path where tfstate file will be stored


whenever we are performing write operations, terraform will lock our state file.
<!-- STATE LOCKING IN S3 -->

1. by default, s3 doesnot support state locking functionality
2. we need to make use of dynamoDB table to achieve state locking functionality.
3. tfstate file will be stored in s3 bucket and .state.lock file will be stored in dynamo DB



##### ######################################3
<!-- TERRAFORM STATE MANAGEMENT -->
we can play with state file by using state command
list, mv, pull, push, rm and , show

> terraform state list
this command is used to list resource within a terraform state
> terraform state mv [options] SOURCE DESTINATION
this ommand is used to move items in a terraform state. used when we want to rename an existing source without recreating or destroying it. due to destructive nature of this command , this command will output a backup copy of state prior to save any changes.
> terraform state pull
this command is used to manualy download and output the state from remote state.used for reading value out of state..
> terraform state push
this command is used to manually push/upload a local state file to remote state. this command should rarely be used.
> terraform state rm 
is used to remove items from a tf state.item removed from tfstate are not physcially destroyed 
> terraform state show [resource.localname]
this cmd is used to show attributes of single resource in the terraform state.

<!-- connecting remote state | cross project collaboration using remote state -->
terraform_remote_state data sources retrives the root module output values from some other terraform configuration, using latest snapshot from remote backend

##### ####################################################
<!-- TERRAFORM IMPORT -->
tf is able to import existing infra.
this allow us to take resource we have created by some other means, and bring it under tf mangement,
whenever we use tf import, the state file gets created automatically and the resource vonfigruaetion file(will be created manuallyu)



terraform import aws_instance.myec2 <instance_id>




#################################################################################\
#### ##################################################
<!-- TERRAFORM CLOUD -->
Terraform cloud manages the terraform runs in a consistent and reliable environment with various features like access control, private registry for sharing modules, policy controls and others.
state files are also maintained in cloud itself, and their are option of apply, run or discard run and we can also mention the reason for them. we also have policy check option.
we can also add variables.  
terraform also provide option of private registry for sharing the module.

we can configure git repo with terraform cloud via VCS provider in settingns. VSC is version control workflow

if we add new resources in terraform cloud in github, it will autoamtically apply terraform plan...

<!-- SENTINEL -->
sentinel is policy as code freamerwork which is integrated with hashicorp enterprises producrs.
it enables fine grained, logic based policy decisions and can be extended to use info from other resources.
sentinel policy are paid features.


##### #######################################
<!-- REMOTE BACKEND -->
remote backend stores tf state and used to run operations in tf cloud.
tf cloud can also be used for local operations, in which case only state is stored in tf cloud backend.
backend operations:- local, remote.
when using full remote operations , operations like terraform plan or apply can be executed in tf cloud environment , with log output straming to local terminal.


##### ###################################
<!-- AIR GAPED ENVIRONMENTS -->
an air gap is a network security measure employed to ensure that a secure computer network is physcially isolated from unsecured networks such as pubic internet.















