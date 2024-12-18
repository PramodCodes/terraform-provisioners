
#aws provider version 5.81.0
resource "aws_instance" "web" {
  ami           = "ami-0b4f379183e5706b9"   # Centos-8-DevOps-Practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop-all.id]
  tags = {
    Name = "provisioner"
  }

provisioner "local-exec"{
  # command = "echo the server's IP addresss is ${self.private_ip}"
  command = "echo ${self.private_ip} > inventory"
}


# provisioner "local-exec"{
#    #this is the way we will use , this will fail now becasue we are using Tf in local windows env
#   command = "ansible-playbook -i inventory web.yaml"
# }
provisioner "local-exec"{
   #this is the way we will use , this will fail now becasue we are using Tf in local windows env
  command = "echo this runs when being destoryed"
  when = destroy
}
provisioner "local-exec"{
   #this is the way we will use , this will fail now becasue we are using Tf in local windows env
  when = create
  command = "echo this runs when being created"
}

  
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'this is from remote exec' > /tmp/remote.txt",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_security_group" "roboshop-all" { 
    name        = "provisioner"

    ingress {
        description      = "Allow All ports"
        from_port        = 22 
        to_port          = 22 
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Allow All ports"
        from_port        = 80 
        to_port          = 80 
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "provisioner"
    }

}
