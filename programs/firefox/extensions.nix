{ config, lib, pkgs }:
{
    force = true;
    settings."{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        force = true;
        settings.keyMappings = ''
            unmap x
            unmap X
            map C removeTab
            map c restoreTab
        '';
    };
}
