# The MIT License (MIT)
#
# Copyright (c) 2015 Microsoft Azure
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Download and invoke the Mirantis Container Runtime installer. See: https://docs.mirantis.com/mcr/20.10/install/mcr-windows.html
# The Mirantis installer automatically checks for containers feature enablement and turns the feature on if it's not already. 
Invoke-WebRequest -UseBasicParsing -Uri https://get.mirantis.com/install.ps1 -o install.ps1

# Invoke the MCR installer (this will require a reboot)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Scope Process;
.\install.ps1

# Reboot to complete installation of MCR
Restart-Computer -Force