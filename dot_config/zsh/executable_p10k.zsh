 current terraform workspace gets matched.
    # More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
    # that gets matched. If you unset all POWERLEVEL9K_TERRAFORM_*CONTENT_EXPANSION parameters,
    # you'll see this value in your prompt. The second element of each pair in
    # POWERLEVEL9K_TERRAFORM_CLASSES defines the workspace class. Patterns are tried in order. The
    # first match wins.
    #
    # For example, given these settings:
    #
    #   typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
    #     '*prod*'  PROD
    #     '*test*'  TEST
    #     '*'       OTHER)
    #
    # If your current terraform workspace is "project_test", its class is TEST because "project_test"
    # doesn't match the pattern '*prod*' but does match '*test*'.
    #
    # You can define different colors, icons and content expansions for different classes:
    #
    #   typeset -g POWERLEVEL9K_TERRAFORM_TEST_FOREGROUND=2
    #   typeset -g POWERLEVEL9K_TERRAFORM_TEST_BACKGROUND=0
    #   typeset -g POWERLEVEL9K_TERRAFORM_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
    #   typeset -g POWERLEVEL9K_TERRAFORM_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
    typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
        # '*prod*'  PROD    # These values are examples that are unlikely
        # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'         OTHER)
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=4
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_BACKGROUND=0
    # typeset -g POWERLEVEL9K_TERRAFORM_OTHER_VISUAL_IDENTIFIER_EXPANSION='⭐'

    #############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
    # Show kubecontext only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show kubecontext.
    typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|fluxctl|stern'

    # Kubernetes context classes for the purpose of using different colors, icons and expansions with
    # different contexts.
    #
    # POWERLEVEL9K_KUBECONTEXT_CLASSES is an array with even number of elements. The first element
    # in each pair defines a pattern against which the current kubernetes context gets matched.
    # More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
    # that gets matched. If you unset all POWERLEVEL9K_KUBECONTEXT_*CONTENT_EXPANSION parameters,
    # you'll see this value in your prompt. The second element of each pair in
    # POWERLEVEL9K_KUBECONTEXT_CLASSES defines the context class. Patterns are tried in order. The
    # first match wins.
    #
    # For example, given these settings:
    #
    #   typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    #     '*prod*'  PROD
    #     '*test*'  TEST
    #     '*'       DEFAULT)
    #
    # If your current kubernetes context is "deathray-testing/default", its class is TEST
    # because "deathray-testing/default" doesn't match the pattern '*prod*' but does match '*test*'.
    #
    # You can define different colors, icons and content expansions for different classes:
    #
    #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_FOREGROUND=0
    #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_BACKGROUND=2
    #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
    #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
    typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
        # '*prod*'  PROD    # These values are examples that are unlikely
        # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'       DEFAULT)
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=5
    # typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

    # Use POWERLEVEL9K_KUBECONTEXT_CONTENT_EXPANSION to specify the content displayed by kubecontext
    # segment. Parameter expansions are very flexible and fast, too. See reference:
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion.
    #
    # Within the expansion the following parameters are always available:
    #
    # - P9K_CONTENT                The content that would've been displayed if there was no content
    #                              expansion defined.
    # - P9K_KUBECONTEXT_NAME       The current context's name. Corresponds to column NAME in the
    #                              output of `kubectl config get-contexts`.
    # - P9K_KUBECONTEXT_CLUSTER    The current context's cluster. Corresponds to column CLUSTER in the
    #                              output of `kubectl config get-contexts`.
    # - P9K_KUBECONTEXT_NAMESPACE  The current context's namespace. Corresponds to column NAMESPACE
    #                              in the output of `kubectl config get-contexts`. If there is no
    #                              namespace, the parameter is set to "default".
    # - P9K_KUBECONTEXT_USER       The current context's user. Corresponds to column AUTHINFO in the
    #                              output of `kubectl config get-contexts`.
    #
    # If the context points to Google Kubernetes Engine (GKE) or Elastic Kubernetes Service (EKS),
    # the following extra parameters are available:
    #
    # - P9K_KUBECONTEXT_CLOUD_NAME     Either "gke" or "eks".
    # - P9K_KUBECONTEXT_CLOUD_ACCOUNT  Account/project ID.
    # - P9K_KUBECONTEXT_CLOUD_ZONE     Availability zone.
    # - P9K_KUBECONTEXT_CLOUD_CLUSTER  Cluster.
    #
    # P9K_KUBECONTEXT_CLOUD_* parameters are derived from P9K_KUBECONTEXT_CLUSTER. For example,
    # if P9K_KUBECONTEXT_CLUSTER is "gke_my-account_us-east1-a_my-cluster-01":
    #
    #   - P9K_KUBECONTEXT_CLOUD_NAME=gke
    #   - P9K_KUBECONTEXT_CLOUD_ACCOUNT=my-account
    #   - P9K_KUBECONTEXT_CLOUD_ZONE=us-east1-a
    #   - P9K_KUBECONTEXT_CLOUD_CLUSTER=my-cluster-01
    #
    # If P9K_KUBECONTEXT_CLUSTER is "arn:aws:eks:us-east-1:123456789012:cluster/my-cluster-01":
    #
    #   - P9K_KUBECONTEXT_CLOUD_NAME=eks
    #   - P9K_KUBECONTEXT_CLOUD_ACCOUNT=123456789012
    #   - P9K_KUBECONTEXT_CLOUD_ZONE=us-east-1
    #   - P9K_KUBECONTEXT_CLOUD_CLUSTER=my-cluster-01
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
    # Show P9K_KUBECONTEXT_CLOUD_CLUSTER if it's not empty and fall back to P9K_KUBECONTEXT_NAME.
    POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
    # Append the current context's namespace if it's not "default".
    POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

    # Custom prefix.
    # typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='at '

    #[ aws: aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) ]#
    # Show aws only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show aws.
    typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|terraform|pulumi|terragrunt'

    # POWERLEVEL9K_AWS_CLASSES is an array with even number of elements. The first element
    # in each pair defines a pattern against which the current AWS profile gets matched.
    # More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
    # that gets matched. If you unset all POWERLEVEL9K_AWS_*CONTENT_EXPANSION parameters,
    # you'll see this value in your prompt. The second element of each pair in
    # POWERLEVEL9K_AWS_CLASSES defines the profile class. Patterns are tried in order. The
    # first match wins.
    #
    # For example, given these settings:
    #
    #   typeset -g POWERLEVEL9K_AWS_CLASSES=(
    #     '*prod*'  PROD
    #     '*test*'  TEST
    #     '*'       DEFAULT)
    #
    # If your current AWS profile is "company_test", its class is TEST
    # because "company_test" doesn't match the pattern '*prod*' but does match '*test*'.
    #
    # You can define different colors, icons and content expansions for different classes:
    #
    #   typeset -g POWERLEVEL9K_AWS_TEST_FOREGROUND=28
    #   typeset -g POWERLEVEL9K_AWS_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
    #   typeset -g POWERLEVEL9K_AWS_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
    typeset -g POWERLEVEL9K_AWS_CLASSES=(
        # '*prod*'  PROD    # These values are examples that are unlikely
        # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'       DEFAULT)
    typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_AWS_DEFAULT_BACKGROUND=1
    # typeset -g POWERLEVEL9K_AWS_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

    #[ aws_eb_env: aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/) ]#
    # AWS Elastic Beanstalk environment color.
    typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=2
    typeset -g POWERLEVEL9K_AWS_EB_ENV_BACKGROUND=0
    # Custom icon.
    # typeset -g POWERLEVEL9K_AWS_EB_ENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ##########[ azure: azure account name (https://docs.microsoft.com/en-us/cli/azure) ]##########
    # Show azure only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show azure.
    typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|pulumi|terragrunt'
    # Azure account name color.
    typeset -g POWERLEVEL9K_AZURE_FOREGROUND=7
    typeset -g POWERLEVEL9K_AZURE_BACKGROUND=4
    # Custom icon.
    # typeset -g POWERLEVEL9K_AZURE_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ##########[ gcloud: google cloud account and project (https://cloud.google.com/) ]###########
    # Show gcloud only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show gcloud.
    typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
    # Google cloud color.
    typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=7
    typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND=4

    # Google cloud format. Change the value of POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION and/or
    # POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION if the default is too verbose or not informative
    # enough. You can use the following parameters in the expansions. Each of them corresponds to the
    # output of `gcloud` tool.
    #
    #   Parameter                | Source
    #   -------------------------|--------------------------------------------------------------------
    #   P9K_GCLOUD_CONFIGURATION | gcloud config configurations list --format='value(name)'
    #   P9K_GCLOUD_ACCOUNT       | gcloud config get-value account
    #   P9K_GCLOUD_PROJECT_ID    | gcloud config get-value project
    #   P9K_GCLOUD_PROJECT_NAME  | gcloud projects describe $P9K_GCLOUD_PROJECT_ID --format='value(name)'
    #
    # Note: ${VARIABLE//\%/%%} expands to ${VARIABLE} with all occurrences of '%' replaced with '%%'.
    #
    # Obtaining project name requires sending a request to Google servers. This can take a long time
    # and even fail. When project name is unknown, P9K_GCLOUD_PROJECT_NAME is not set and gcloud
    # prompt segment is in state PARTIAL. When project name gets known, P9K_GCLOUD_PROJECT_NAME gets
    # set and gcloud prompt segment transitions to state COMPLETE.
    #
    # You can customize the format, icon and colors of gcloud segment separately for states PARTIAL
    # and COMPLETE. You can also hide gcloud in state PARTIAL by setting
    # POWERLEVEL9K_GCLOUD_PARTIAL_VISUAL_IDENTIFIER_EXPANSION and
    # POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION to empty.
    typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
    typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'

    # Send a request to Google (by means of `gcloud projects describe ...`) to obtain project name
    # this often. Negative value disables periodic polling. In this mode project name is retrieved
    # only when the current configuration, account or project id changes.
    typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60

    # Custom icon.
    # typeset -g POWERLEVEL9K_GCLOUD_VISUAL_IDENTIFIER_EXPANSION='⭐'

    #[ google_app_cred: google application credentials (https://cloud.google.com/docs/authentication/production) ]#
    # Show google_app_cred only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show google_app_cred.
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_SHOW_ON_COMMAND='terraform|pulumi|terragrunt'

    # Google application credentials classes for the purpose of using different colors, icons and
    # expansions with different credentials.
    #
    # POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES is an array with even number of elements. The first
    # element in each pair defines a pattern against which the current kubernetes context gets
    # matched. More specifically, it's P9K_CONTENT prior to the application of context expansion
    # (see below) that gets matched. If you unset all POWERLEVEL9K_GOOGLE_APP_CRED_*CONTENT_EXPANSION
    # parameters, you'll see this value in your prompt. The second element of each pair in
    # POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES defines the context class. Patterns are tried in order.
    # The first match wins.
    #
    # For example, given these settings:
    #
    #   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
    #     '*:*prod*:*'  PROD
    #     '*:*test*:*'  TEST
    #     '*'           DEFAULT)
    #
    # If your current Google application credentials is "service_account deathray-testing x@y.com",
    # its class is TEST because it doesn't match the pattern '* *prod* *' but does match '* *test* *'.
    #
    # You can define different colors, icons and content expansions for different classes:
    #
    #   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_FOREGROUND=28
    #   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
    #   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_CONTENT_EXPANSION='$P9K_GOOGLE_APP_CRED_PROJECT_ID'
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
        # '*:*prod*:*'  PROD    # These values are examples that are unlikely
        # '*:*test*:*'  TEST    # to match your needs. Customize them as needed.
    '*'             DEFAULT)
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=7
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_BACKGROUND=4
    # typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

    # Use POWERLEVEL9K_GOOGLE_APP_CRED_CONTENT_EXPANSION to specify the content displayed by
    # google_app_cred segment. Parameter expansions are very flexible and fast, too. See reference:
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion.
    #
    # You can use the following parameters in the expansion. Each of them corresponds to one of the
    # fields in the JSON file pointed to by GOOGLE_APPLICATION_CREDENTIALS.
    #
    #   Parameter                        | JSON key file field
    #   ---------------------------------+---------------
    #   P9K_GOOGLE_APP_CRED_TYPE         | type
    #   P9K_GOOGLE_APP_CRED_PROJECT_ID   | project_id
    #   P9K_GOOGLE_APP_CRED_CLIENT_EMAIL | client_email
    #
    # Note: ${VARIABLE//\%/%%} expands to ${VARIABLE} with all occurrences of '%' replaced by '%%'.
    typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_CONTENT_EXPANSION='${P9K_GOOGLE_APP_CRED_PROJECT_ID//\%/%%}'
    ##############[ toolbox: toolbox name (https://github.com/containers/toolbox) ]###############
    # Toolbox color.
    typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND=0
    typeset -g POWERLEVEL9K_TOOLBOX_BACKGROUND=3
    # Don't display the name of the toolbox if it matches fedora-toolbox-*.
    typeset -g POWERLEVEL9K_TOOLBOX_CONTENT_EXPANSION='${P9K_TOOLBOX_NAME:#fedora-toolbox-*}'
    # Custom icon.
    # typeset -g POWERLEVEL9K_TOOLBOX_VISUAL_IDENTIFIER_EXPANSION='⭐'
    # Custom prefix.
    # typeset -g POWERLEVEL9K_TOOLBOX_PREFIX='in '

    ###############################[ public_ip: public IP address ]###############################
    # Public IP color.
    typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=7
    typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=0
    # Custom icon.
    # typeset -g POWERLEVEL9K_PUBLIC_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ########################[ vpn_ip: virtual private network indicator ]#########################
    # VPN IP color.
    typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=0
    typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND=6
    # When on VPN, show just an icon without the IP address.
    # Tip: To display the private IP address when on VPN, remove the next line.
    typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
    # Regular expression for the VPN network interface. Run `ifconfig` or `ip -4 a show` while on VPN
    # to see the name of the interface.
    typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*|(zt.*)'
    # If set to true, show one segment per matching network interface. If set to false, show only
    # one segment corresponding to the first matching network interface.
    # Tip: If you set it to true, you'll probably want to unset POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION.
    typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false
    # Custom icon.
    # typeset -g POWERLEVEL9K_VPN_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ###########[ ip: ip address and bandwidth usage for a specified network interface ]###########
    # IP color.
    typeset -g POWERLEVEL9K_IP_BACKGROUND=4
    typeset -g POWERLEVEL9K_IP_FOREGROUND=0
    # The following parameters are accessible within the expansion:
    #
    #   Parameter             | Meaning
    #   ----------------------+---------------
    #   P9K_IP_IP         | IP address
    #   P9K_IP_INTERFACE  | network interface
    #   P9K_IP_RX_BYTES   | total number of bytes received
    #   P9K_IP_TX_BYTES   | total number of bytes sent
    #   P9K_IP_RX_RATE    | receive rate (since last prompt)
    #   P9K_IP_TX_RATE    | send rate (since last prompt)
    # typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_RX_RATE:+⇣$P9K_IP_RX_RATE }${P9K_IP_TX_RATE:+⇡$P9K_IP_TX_RATE }$P9K_IP_IP'
    # I just need the fucking ip nothing else
    typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='$P9K_IP_IP'
    # Show information for the first network interface whose name matches this regular expression.
    # Run `ifconfig` or `ip -4 a show` to see the names of all network interfaces.
    typeset -g POWERLEVEL9K_IP_INTERFACE='[ew].*'
    # Custom icon.
    # typeset -g POWERLEVEL9K_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

    #########################[ proxy: system-wide http/https/ftp proxy ]##########################
    # Proxy color.
    typeset -g POWERLEVEL9K_PROXY_FOREGROUND=4
    typeset -g POWERLEVEL9K_PROXY_BACKGROUND=0
    # Custom icon.
    # typeset -g POWERLEVEL9K_PROXY_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ################################[ battery: internal battery ]#################################
    # Show battery in red when it's below this level and not connected to power supply.
    typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
    typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
    # Show battery in green when it's charging or fully charged.
    typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=2
    # Show battery in yellow when it's discharging.
    typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3
    # Battery pictograms going from low to high level of charge.
    typeset -g POWERLEVEL9K_BATTERY_STAGES='\uf58d\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'
    # Don't show the remaining time to charge/discharge.

    typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=0

    #####################################[ wifi: wifi speed ]#####################################
    # WiFi color.
    typeset -g POWERLEVEL9K_WIFI_FOREGROUND=0
    typeset -g POWERLEVEL9K_WIFI_BACKGROUND=4
    # Custom icon.
    # typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='⭐'

    # Use different colors and icons depending on signal strength ($P9K_WIFI_BARS).
    #
    #   # Wifi colors and icons for different signal strength levels (low to high).
    #   typeset -g my_wifi_fg=(0 0 0 0 0)                                # <-- change these values
    #   typeset -g my_wifi_icon=('WiFi' 'WiFi' 'WiFi' 'WiFi' 'WiFi')     # <-- change these values
    #
    #   typeset -g POWERLEVEL9K_WIFI_CONTENT_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}$P9K_WIFI_LAST_TX_RATE Mbps'
    #   typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}${my_wifi_icon[P9K_WIFI_BARS+1]}'
    #
    # The following parameters are accessible within the expansions:
    #
    #   Parameter             | Meaning
    #   ----------------------+---------------
    #   P9K_WIFI_SSID         | service set identifier, a.k.a. network name
    #   P9K_WIFI_LINK_AUTH    | authentication protocol such as "wpa2-psk" or "none"; empty if unknown
    #   P9K_WIFI_LAST_TX_RATE | wireless transmit rate in megabits per second
    #   P9K_WIFI_RSSI         | signal strength in dBm, from -120 to 0
    #   P9K_WIFI_NOISE        | noise in dBm, from -120 to 0
    #   P9K_WIFI_BARS         | signal strength in bars, from 0 to 4 (derived from P9K_WIFI_RSSI and P9K_WIFI_NOISE)

    ####################################[ time: current time ]####################################
    # Current time color.
    typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
    typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
    # Format for the current time: 09:51:02. See `man 3 strftime`.
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
    # If set to true, time will update when you hit enter. This way prompts for the past
    # commands will contain the start times of their commands as opposed to the default
    # behavior where they contain the end times of their preceding commands.
    typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
    # Custom icon.
    # typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='⭐'
    # Custom prefix.
    # typeset -g POWERLEVEL9K_TIME_PREFIX='at '

    # Example of a user-defined prompt segment. Function prompt_example will be called on every
    # prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
    # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and yellow text on red background
    # greeting the user.
    #
    # Type `p10k help segment` for documentation and a more sophisticated example.
    function prompt_example() {
        p10k segment -b 1 -f 3 -i '⭐' -t 'hello, %n'
    }

    # User-defined prompt segments may optionally provide an instant_prompt_* function. Its job
    # is to generate the prompt segment for display in instant prompt. See
    # https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
    #
    # Powerlevel10k will call instant_prompt_* at the same time as the regular prompt_* function
    # and will record all `p10k segment` calls it makes. When displaying instant prompt, Powerlevel10k
    # will replay these calls without actually calling instant_prompt_*. It is imperative that
    # instant_prompt_* always makes the same `p10k segment` calls regardless of environment. If this
    # rule is not observed, the content of instant prompt will be incorrect.
    #
    # Usually, you should either not define instant_prompt_* or simply call prompt_* from it. If
    # instant_prompt_* is not defined for a segment, the segment won't be shown in instant prompt.
    function instant_prompt_example() {
        # Since prompt_example always makes the same `p10k segment` calls, we can call it from
        # instant_prompt_example. This will give us the same `example` prompt segment in the instant
        # and regular prompts.
        prompt_example
    }

    # User-defined prompt segments can be customized the same way as built-in segments.
    typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=3
    typeset -g POWERLEVEL9K_EXAMPLE_BACKGROUND=1
    # typeset -g POWERLEVEL9K_EXAMPLE_VISUAL_IDENTIFIER_EXPANSION='⭐'

    # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
    # when accepting a command line. Supported values:
    #
    #   - off:      Don't change prompt when accepting a command line.
    #   - always:   Trim down prompt when accepting a command line.
    #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
    #               typed after changing current working directory.
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

    # Instant prompt mode.
    #
    #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
    #              it incompatible with your zsh configuration files.
    #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
    #              during zsh initialization. Choose this if you've read and understood
    #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
    #   - verbose: Enable instant prompt and print a warning when detecting console output during
    #              zsh initialization. Choose this if you've never tried instant prompt, haven't
    #              seen the warning, or if you are unsure what this all means.
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

    # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
    # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
    # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
    # really need it.
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    # If p10k is already loaded, reload configuration.
    # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
    (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
