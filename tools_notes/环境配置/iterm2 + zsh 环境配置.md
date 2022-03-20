---
title: iterm2 + zsh 环境配置
date: 2022-01-26 00:00:00
tags: zsh
categories: 重剑无锋
---

# 1. 先安装homebrew 和 iterm2
# 2. 从catalina开始，zsh是所有新建用户账户的默认shell，不需要重新安装。
# 3. 安装 oh-my-zsh 。
https://github.com/ohmyzsh/ohmyzsh

# 4. 安装 两个插件： 
git clone  https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 5.编辑.zshrc文件
# 6. 安装主题， powerlevel10k
https://github.com/romkatv/powerlevel10k#homebrew

# 7.安装colorls
https://github.com/athityakumar/colorls
sudo gem install colorls

# 8.代码统计工具
brew install cloc
