$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'On Prem Apps Demo'
            description  = 'This flexible asset will help specifying on prem applications.'
            icon = 'cogs'
            enabled = $true
            show_in_menu = $true
        }
        relationships = @{
            flexible_asset_fields = @{
                data = @(
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 1
                            name = 'Application name'
                            kind = 'Select'
                            hint = 'Select from the list the application you want to document. Any application missing may be added under account, flexible asset types.'
                            default_value = "mDaemon`r`n" `
                                          + "Kaseya VSA`r`n" `
                                          + "Kaseya Traverse`r`n" `
                                          + "Network Detective`r`n" `
                                          + "-----------------------------`r`n" `
                                          + "Adobe Photoshop`r`n" `
                                          + "Adobe Premiere`r`n" `
                                          + "AutoCAD`r`n" `
                                          + "Microsoft Office`r`n" `
                                          + "Visma Administration`r`n" `
                                          + "VMware Workstation`r`n" `
                                          + "Not on the list (ask admin to add)"
                            required = $true
                            show_in_list = $true
                            use_for_title = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'License information'
                            kind = 'Header'
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 3
                            name = 'License key'
                            kind = 'Text'
                            hint = 'Enter the current license key for this application.'
                            default_value = ''
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 4
                            name = 'License expires'
                            kind = 'Date'
                            hint = 'Enter the expiration date for the license.'
                            expiration = $true
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 5
                            name = 'License volume'
                            kind = 'Number'
                            hint = 'How many licenses?'
                            decimals = 0
                            default_value = ''
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 6
                            name = 'Important contacts'
                            kind = 'Header'
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 7
                            name = 'Application admin(s) at the customer'
                            kind = 'Tag'
                            hint = 'Do the customer have specific application administrator(s) for this application?'
                            tag_type = 'Contacts'
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 8
                            name = 'Financial application owner at the customer'
                            kind = 'Tag'
                            hint = 'Who pays the bills? Can be the same as the application administrator.'
                            tag_type = "Contacts"
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 9
                            name = 'Our specialist(s)'
                            kind = 'Tag'
                            hint = 'Who is our application spcialist(s)?'
                            tag_type = 'AccountsUsers'
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 10
                            name = 'Application setup'
                            kind = 'Header'
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 11
                            name = 'Application version'
                            kind = 'Text'
                            hint = 'Try to add the version of the application by name: 2010, 2016, 6.7, LT, Advanced'
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 12
                            name = 'Associated servers(s) or computer(s)'
                            kind = 'Tag'
                            hint = 'Tag the server(s) or computers(s) running this application'
                            tag_type = 'Configurations'
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 13
                            name = 'Application URL (if available)'
                            kind = 'Text'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 14
                            name = 'How is this application delivered?'
                            kind = 'Select'
                            hint = ''
                            default_value = "Centralized from one or more servers`r`n" `
                                          + "Locally from a computer"
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 15
                            name = 'Application User Interface'
                            kind = 'Select'
                            hint = 'Is this a web browser based application or does it require a software installation?'
                            default_value = "Browser based only`r`n" `
                                          + "Local software only`r`n" `
                                          + "Mobile App only`r`n" `
                                          + "Browser and Mobile App`r`n" `
                                          + "Browser and local software`r`n" `
                                          + "Browser, local software and mobile App"
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 16
                            name = 'Is there any SSL certificate(s) used by this application'
                            kind = 'Tag'
                            hint = ''
                            tag_type = 'SslCertificates'
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 17
                            name = 'Client installation name'
                            kind = 'Text'
                            hint = 'Does this application require any client installation for computers? If so, what is the name of this client?'
                            default_value = ''
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 18
                            name = 'RMM Deploy script'
                            kind = 'Text'
                            hint = 'Does this application have any RMM deploy script for easy deployment?'
                            default_value = ''
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 19
                            name = 'Password and security'
                            kind = 'Header'
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 20
                            name = 'Password(s)'
                            kind = 'Tag'
                            hint = 'Tag the password(s) associated with this app for administration purposes.'
                            tag_type = 'Passwords'
                            required = $false
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 21
                            name = 'Security groups or privileges required?'
                            kind = 'Textbox'
                            hint = 'Is there any requirements on local or domain admin groups in order to run this application?'
                            default_value = ''
                            required = $false
                            show_in_list = $false
                        }
                    }
                )
            }
        }
    }
}
New-ITGlueFlexibleAssetTypes -data $body