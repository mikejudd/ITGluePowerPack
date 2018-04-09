$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'Office 365 Users'
            description = 'All your internal Office 365 users.'
            icon = 'soundcloud'
            show_in_menu = $true
        }
        relationships = @{
            flexible_asset_fields = @{
                data = @(
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 1
                            name = 'User'
                            kind = 'Tag'
                            hint = 'Who is this person?'
                            tag_type = 'Contacts'
                            required = $true
                            show_in_list = $true
                            use_for_title = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'License type'
                            kind = 'Select'
                            hint = 'Which version of Office 365 is it?'
                            default_value = "Business`r`n" `
                                          + "Business Essentials`r`n" `
                                          + "Business Premium`r`n" `
                                          + "ProPlus`r`n" `
                                          + "Enterprise E1`r`n" `
                                          + "Enterprise E3`r`n" `
                                          + "Enterprise E5" `
                                          + "No license"
                            required = $true
                            use_for_title = $false
                        }
                    }
                )
            }
        }
    }
}
New-ITGlueFlexibleAssetTypes -data $body