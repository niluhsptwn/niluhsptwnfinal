import 'dart:io';

class LapanganFutsal {
  final String nama;
  final int kapasitas;

  LapanganFutsal({required this.nama, required this.kapasitas});
}

class Reservasi {
  final String idLapangan;
  final String namaPelanggan;
  final DateTime waktuMulai;
  final DateTime waktuSelesai;

  Reservasi({
    required this.idLapangan,
    required this.namaPelanggan,
    required this.waktuMulai,
    required this.waktuSelesai,
  });
}

class Node {
  Reservasi data;
  Node? next;

  Node(this.data);
}

class ReservasiQueue {
  Node? front;
  Node? back;

  void add(Reservasi reservasi) {
    var newNode = Node(reservasi);
    if (isEmpty()) {
      front = newNode;
    } else {
      back!.next = newNode;
    }
    back = newNode;
    print('Reservasi untuk ${reservasi.namaPelanggan} telah dibuat.');
  }

  Reservasi? remove() {
    if (isEmpty()) return null;
    var removedNode = front!;
    front = front!.next;
    if (front == null) {
      back = null;
    }
    return removedNode.data;
  }

  bool isEmpty() => front == null;

  void hapusReservasiKadaluarsa() {
    DateTime sekarang = DateTime.now();
    while (!isEmpty() && front!.data.waktuSelesai.isBefore(sekarang)) {
      remove();
    }
    print('Reservasi kadaluarsa telah dihapus.');
  }

  List<Reservasi> get elements {
    List<Reservasi> list = [];
    var current = front;
    while (current != null) {
      list.add(current.data);
      current = current.next;
    }
    return list;
  }
}

class ManajemenLapangan {
  LapanganFutsal lapangan = LapanganFutsal(nama: 'Megji Futsal Center', kapasitas: 10);
  ReservasiQueue reservasiQueue = ReservasiQueue();

  void buatReservasi(Reservasi reservasi) {
    if (bedaReservasi(reservasi)) {
      print('Reservasi gagal: Waktu reservasi sama dengan reservasi yang sudah ada.');
    } else {
      reservasiQueue.add(reservasi);
    }
  }

  bool bedaReservasi(Reservasi reservasiBaru) {
    return reservasiQueue.elements.any((reservasi) =>
        reservasi.idLapangan == reservasiBaru.idLapangan &&
        (reservasiBaru.waktuMulai.isBefore(reservasi.waktuSelesai) && reservasiBaru.waktuSelesai.isAfter(reservasi.waktuMulai)));
  }

  void tampilkanLapangan() {
    print('Lapangan: ${lapangan.nama} (Kapasitas: ${lapangan.kapasitas})');
  }

  void tampilkanReservasi() {
    if (reservasiQueue.isEmpty()) {
      print('Belum ada reservasi.');
    } else {
      print('Daftar Reservasi:');
      for (var reservasi in reservasiQueue.elements) {
        print('${reservasi.namaPelanggan} - Lapangan: ${reservasi.idLapangan} (Dari: ${reservasi.waktuMulai} Sampai: ${reservasi.waktuSelesai})');
      }
    }
  }
}

void main() {
  var manajemen = ManajemenLapangan();

  while (true) {
    print('\n=== Sistem Reservasi Lapangan Futsal ===');
    print('1. Buat Reservasi');
    print('2. Tampilkan Lapangan');
    print('3. Tampilkan Reservasi');
    print('4. Hapus Reservasi Kadaluarsa');
    print('5. Keluar');
    stdout.write('Pilih menu: ');
    var pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        stdout.write('Masukkan Nama Pelanggan: ');
        var namaPelanggan = stdin.readLineSync()!;
        stdout.write('Masukkan Waktu Mulai (YYYY-MM-DD HH:MM): ');
        var waktuMulai = DateTime.parse(stdin.readLineSync()!);
        stdout.write('Masukkan Waktu Selesai (YYYY-MM-DD HH:MM): ');
        var waktuSelesai = DateTime.parse(stdin.readLineSync()!);
        manajemen.buatReservasi(Reservasi(idLapangan: manajemen.lapangan.nama, namaPelanggan: namaPelanggan, waktuMulai: waktuMulai, waktuSelesai: waktuSelesai));
        break;
      case '2':
        manajemen.tampilkanLapangan();
        break;
      case '3':
        manajemen.tampilkanReservasi();
        break;
      case '4':
        manajemen.reservasiQueue.hapusReservasiKadaluarsa();
        break;
      case '5':
        print('Terima kasih telah menggunakan sistem ini.');
        exit(0);
      default:
        print('Pilihan tidak valid, coba lagi.');
    }
  }
}