$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'Incidents'
            description  = 'For logging major incidents'
            icon = 'clock-o'
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
                            name = 'Incident'
                            kind = 'Text'
                            hint = 'And incident number'
                            show_in_list = $true
                            use_for_title = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'Affected Assets'
                            kind = 'Tag'
                            tag_type = 'Configurations'
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 3
                            name = 'Date'
                            kind = 'Date'
                            hint = ''
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 4
                            name = 'Severity'
                            kind = 'Select'
                            hint = 'Affected users?'
                            default_value = "One User`r`n" `
                                          + "Multiple Users`r`n" `
                                          + "Whole CompanyKaseya BMS"
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 5
                            name = 'Which users?'
                            kind = 'Tag'
                            hint = 'Tag all the affected users'
                            tag_type = 'Contacts'
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 6
                            name = 'Details'
                            kind = 'Textbox'
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 7
                            name = 'Solution'
                            kind = 'Textbox'
                            hint = 'What is done to solve the incident'
                            show_in_list = $false
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 8
                            name = 'Responsible'
                            kind = 'Tag'
                            hint = 'Who is responsible?'
                            tag_type = "Contacts"
                            show_in_list = $true
                        }
                    }
                )
            }
        }
    }
}
New-ITGlueFlexibleAssetTypes -data $body