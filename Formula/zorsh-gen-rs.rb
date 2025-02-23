class ZorshGenRs < Formula
  desc "Zorsh generator for Rust"
  homepage "https://zorsh.dev"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.4/zorsh-gen-rs-aarch64-apple-darwin.tar.xz"
      sha256 "2d83648226a2fa5114bd732273809a178e39cd3a331d4b5bbc464225fb030aa2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.4/zorsh-gen-rs-x86_64-apple-darwin.tar.xz"
      sha256 "4a9cbab2d69ddd4458ee147c926698c36114cccca50244fa03940e2644e438e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.4/zorsh-gen-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0737915cf97c2a5e8e4bc1ad9912429cd0536a1d06a38bceece9c50a8eac6baf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r-near/zorsh-gen-rs/releases/download/v0.1.4/zorsh-gen-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5490b2461ac62fe29d2c5eee22240a0ca21918fff99bd84d6becd236a00ba63"
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
