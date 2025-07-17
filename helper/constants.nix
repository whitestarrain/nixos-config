{ lib, pkgs, ... }:

{
  email = "kaneki.lusou@gmail.com";
  githubEmail = "55945266+whitestarrain@users.noreply.github.com";
  sshAuthorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBlOIcmmH68ED5TAej0oJnyjK91Hwyl2GPQ6c1sjqr5pe8zeKi2bCnLa3lyZJRjdSWYK3RWhuPubXIZcRkPuy/yrq8ak37V5WlJwl+T0S2avne4LZdtjn8NDM258v8q37Lwjb95OiDtjx0Lozkn53+8SSljrXVvF8YF6d+5cXVXJ3D2zRmgcEFfWyWUNmSR0sBNyIYLwQHtEmnznA2b8e/+ERgKY3PbfVX0OA7gXMeVdnYV0pwcVLpWlDxs+iqygc2i66zzetDS31k5tZCo1h4dCu0D+NU5a0AfTe0Gz1gL1IWb+AMi8xpP2KqQi8ATJ+FpahE/ukMdHqZGupk4vEreq1hYQTufSPmbRVYKiYiSYd4OsFSkLT6Bjqs+IlTV47kOWIVu+n8IDIzBhTWTs/dHutaCNS2VZECt+1kbcOlU7zwPciEuJ31BHnCAQLIlRDJWjB/2PSCdPfh7ydGrTH35PV1t4xPclUOnWV6ra94O5XjexgeDMdfOEMw+VMY1tE= wsain@wsainArch"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDwl2UmzJCwL0C8yXkAvyQz/pzls1xN9BhA73mn75xfYdQ8osr3Xelfq/j644pqKGb3/gUPnpHE1QgAULoDOT76kU3NmWc0riO8NCtvMtvcc163Q3UwJeOkmq3IYtEl/flfMoSW1EvlBljxcpS8Y5t4qqKjFQrgFgexJ5ybo4/WFNM3X2aHBv3pwgudzOp9umcz2DAfY95In5Y1D8oqj4XgvMKeWNzYaVbuDmI4Vw9d7Fe13NEZXhVRZVzByt/hRTVuhrLOF/a5/TsiedmX6EknjXay7KiHavfHvaHOShODruLpumoTR867H5yKNj3JBaLqwF7L5QAM/151RM6yeZX1S3y4eKCEeGILC1byneZi1u8jDiAP74HuMsw2iQlmAHNH9HGOIr+vN0PrcnbMLxlQR/2iJvtHgp77kWVEIz7Rs16FDIgHPdKmZF+0fBv25gqYddfv6TPE1UxDr8dVOj7UZ+3Vel5F06J1gDqmX032N9idWzrjE6p+wHBYWhH7n1k= administrator@DESKTOP-IC5M5IM"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm6Gpu6PJ7zLg9PBloINgndOlqOj/IYwVcEKmNEVATc wsain@R9000K"
  ];
  dnsServers = {
    ipv4 = "8.8.8.8";
    ipv6 = "2001:4860:4860::8888";
  };
}
