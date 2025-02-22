class ZorshGenRs < Formula
  desc "Zorsh generator for Rust"
  homepage "https://zorsh.dev"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.3/zorsh-gen-rs-aarch64-apple-darwin.tar.xz"
      sha256 "33a25133bdaa1139ec8c15250f1739754fbc81e66b9744bd8867d4a48a2139d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.3/zorsh-gen-rs-x86_64-apple-darwin.tar.xz"
      sha256 "d6abe556815b8d299ac9de0728a737f7570bfa2042527a5c3902cac9f9eb501d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.3/zorsh-gen-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "58f57cf6b4fc9f67cf08f8eb285580da29fb74f4d016c4310f83d329ee67ba67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.3/zorsh-gen-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac8009c121c6862a58105e7eeb7458f95b3de58c987399bc2a11625c6245ec7d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "zorsh-gen-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "zorsh-gen-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "zorsh-gen-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "zorsh-gen-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
