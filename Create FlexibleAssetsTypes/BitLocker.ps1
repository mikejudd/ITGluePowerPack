$body = @{
    data = @{
        type = 'flexible_asset_types'
        attributes = @{
            name = 'Bitlocker'
            description = 'Bitlocker encryption information and keys.'
            icon = 'lock'
            show_in_menu = $true
            enabled = $true
        }
        relationships = @{
            flexible_asset_fields = @{
                data = @(
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 1
                            name = 'Computer'
                            kind = 'Tag'
                            hint = ''
                            tag_type = 'Configurations'
                            required = $false
                            show_in_list = $true
                            use_for_title = $true
                        }
                    },
                    @{
                        type = 'flexible_asset_fields'
                        attributes = @{
                            order = 2
                            name = 'KeyProtectorType'
                            kind = 'Tag'
                            hint = ''
                            tag_type = 'Configurations'
                            required = $false
                            show_in_list = $true
                            use_for_title = $true
                        }
                    }
                )
            }
        }
    }
}
New-ITGlueFlexibleAssetTypes -data $body