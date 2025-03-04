#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QRandomGenerator>
#include <cmath>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->checkBox_num, &QCheckBox::checkStateChanged, this, &MainWindow::update_button_state);
    connect(ui->checkBox_let, &QCheckBox::checkStateChanged, this, &MainWindow::update_button_state);
    connect(ui->checkBox_LET, &QCheckBox::checkStateChanged, this, &MainWindow::update_button_state);
    connect(ui->checkBox_oth, &QCheckBox::checkStateChanged, this, &MainWindow::update_button_state);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    std::string chars;
    if (ui->checkBox_num->isChecked()) chars += "0123456789";
    if (ui->checkBox_let->isChecked()) chars += "abcdefghijklmnopqrstuvwxyz";
    if (ui->checkBox_LET->isChecked()) chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (ui->checkBox_oth->isChecked()) chars += R"(!"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~)";

    QString password;
    int len = ui->spinBox_num->value();
    for (int i = 0; i < len; ++i) {
        int index = QRandomGenerator::global()->bounded(chars.length());
        password += chars.at(index);
    }

    ui->lineEdit_pas->setText(password);
    ui->label_2->setText(QString::fromStdString("Password entropy is " + std::to_string(int(ceil(log2(pow(chars.length(), len)))))));


}

void MainWindow::update_button_state()
{
    bool state =  ui->checkBox_num->isChecked() || ui->checkBox_let->isChecked() ||
        ui->checkBox_LET->isChecked() || ui->checkBox_oth->isChecked();
    ui->pushButton->setEnabled(state);
}

