# Main code
from Core.Controller import Controller

def main():
    controller = Controller()
    while not Controller.go_robo(controller):
        continue


if __name__ == "__main__":
    main() 