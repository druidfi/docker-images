group "default" {
  targets = ["node-8", "node-10", "node-12", "node-14", "node-16"]
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "node-8" {
  inherits = ["common"]
  args = {
    NODE_VERSION = 8
  }
  tags = ["druidfi/node:8"]
}

target "node-10" {
  inherits = ["common"]
  args = {
    NODE_VERSION = 10
  }
  tags = ["druidfi/node:10"]
}

target "node-12" {
  inherits = ["common"]
  args = {
    NODE_VERSION = 12
  }
  tags = ["druidfi/node:12"]
}

target "node-14" {
  inherits = ["common"]
  args = {
    NODE_VERSION = 14
  }
  tags = ["druidfi/node:14"]
}

target "node-16" {
  inherits = ["common"]
  args = {
    NODE_VERSION = 16
  }
  tags = ["druidfi/node:16"]
}
