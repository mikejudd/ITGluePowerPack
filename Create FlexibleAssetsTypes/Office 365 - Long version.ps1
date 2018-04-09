$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'Office 365'
            description = 'Document any Office 365 subscription.'
            icon = 'file-word-o'
            show_in_menu = $true
        }
        relationships = @{
            flexible_asset_fields = @{
                data = @(
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 1
                            name = 'Office 365 subscription type'
                            kind = 'Select'
                            hint = 'What subscription is in use for the customer. You will find it under Office Admin Center, billing.'
                            default_value = "Office 365 Business`r`n" `
                                          + "Office 365 Business Essentials`r`n" `
                                          + "Office 365 Business Premium`r`n" `
                                          + "Office 365 ProPlus`r`n" `
                                          + "Office 365 Enterprise E1`r`n" `
                                          + "Office 365 Enterprise E3`r`n" `
                                          + "Office 365 Enterprise E5"
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'The primary O365 domain for the customer.'
                            kind = 'Text'
                            hint = 'Something like customer.onmicrosoft.com'
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 3
                            name = 'Password for the Admin'
                            kind = 'Tag'
                            hint = 'Tag the password for the global admin for this account'
                            tag_type = 'Passwords'
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 4
                            name = 'Company name'
                            kind = 'Text'
                            hint = 'You will find the information here: https://portal.office.com/adminportal/home#/companyprofile'
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 5
                            name = 'Subscription owner'
                            kind = 'Tag'
                            hint = 'Pick from your customer contact list the person paying the bills for this subscription.'
                            tag_type = 'Contacts'
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 6
                            name = 'Technical contact'
                            kind = 'Tag'
                            hint = 'Can be the same as subscription owner. You will find the contact information here: https://portal.office.com/adminportal/home#/companyprofile'
                            tag_type = 'Contacts'
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 7
                            name = 'Subscription renewal time'
                            kind = 'Date'
                            hint = ''
                            expiration = 0
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 8
                            name = 'vbcvc'
                            kind = 'Textbox'
                            hint = ''
                            default_value = ''
                            required = $true
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 9
                            name = 'How many licenses?'
                            kind = 'Number'
                            hint = ''
                            decimals = 0
                            default_value = ''
                            required = $true
                            show_in_list = $true
                        }
                    }
                )
            }
        }
    }
}

New-ITGlueFlexibleAssetTypes -data $body