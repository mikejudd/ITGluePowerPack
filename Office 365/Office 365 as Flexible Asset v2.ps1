$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'Office 365'
            description = 'Document any Office 365 subscription.'
            icon = 'cloud'
            show_in_menu = $true
        }
        relationships = @{
            flexible_asset_fields = @{
                data = @(
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 1
                            name = 'Tenant Name'
                            kind = 'Text'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                            use_for_title = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'Tenant ID'
                            kind = 'Text'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 3
                            name = 'Initial Domain'
                            kind = 'Text'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 4
                            name = 'Verified Domain'
                            kind = 'Textbox'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 5
                            name = 'Liceses'
                            kind = 'Textbox'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 6
                            name = 'Licensed Users'
                            kind = 'Textbox'
                            hint = ''
                            default_value = ''
                            required = $false
                            show_in_list = $true
                        }
                    }
                )
            }
        }
    }
}
New-ITGlueFlexibleAssetTypes -data $body