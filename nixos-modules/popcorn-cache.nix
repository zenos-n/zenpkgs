{ ... }:
{
  # Popcorn is disabled until its binary cache can be consumed reliably.
  # nix.settings = {
  #   substituters = lib.mkAfter [ "https://popcorn-kernel.cachix.org" ];
  #   trusted-public-keys = lib.mkAfter [
  #     "popcorn-kernel.cachix.org-1:K+G41DukvEC4G8sYrrb5ufsAmasSOkWx7KAYtoSmaww="
  #   ];
  # };
}
