{ pkgs }: {
	deps = [
		pkgs.jq.bin
		pkgs.killall
		pkgs.erlang
		pkgs.rebar3
		pkgs.erlang-ls
		pkgs.unixtools.netstat
	];
}