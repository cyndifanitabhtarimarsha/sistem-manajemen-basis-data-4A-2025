CREATE DATABASE rental_mobil;
USE rental_mobil;

SELECT * FROM pelanggan

SELECT * FROM tipe_mobil

SELECT * FROM transaksi

SELECT * FROM detail_transaksi

DROP DATABASE rental_mobil;

RENAME TABLE pelanggan TO pelanggan_rental;

CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat TEXT,
    no_telepon VARCHAR(15),
    email VARCHAR(100)
);

INSERT INTO pelanggan (nama, alamat, no_telepon, email) VALUES
('Andi', 'Jl. Merpati 1', '081234567890', 'andi@gmail.com'),
('Budi', 'Jl. Kenari 2', '082134567891', 'budi@gmail.com'),
('Citra', 'Jl. Elang 3', '083134567892', 'citra@gmail.com'),
('Dina', 'Jl. Rajawali 4', '084134567893', 'dina@gmail.com'),
('Eka', 'Jl. Garuda 5', '085134567894', 'eka@gmail.com'),
('Fajar', 'Jl. Kutilang 6', '086134567895', 'fajar@gmail.com'),
('Gina', 'Jl. Pipit 7', '087134567896', 'gina@gmail.com'),
('Hadi', 'Jl. Camar 8', '088134567897', 'hadi@gmail.com'),
('Indra', 'Jl. Jalak 9', '089134567898', 'indra@gmail.com'),
('Joko', 'Jl. Nuri 10', '081934567899', 'joko@gmail.com');


CREATE TABLE tipe_mobil (
    id_tipe INT AUTO_INCREMENT PRIMARY KEY,
    nama_tipe VARCHAR(100) NOT NULL
);
INSERT INTO tipe_mobil (nama_tipe) VALUES
('SUV'),
('Sedan'),
('Hatchback'),
('MPV'),
('Convertible'),
('Coupe'),
('Pickup'),
('Minivan'),
('Wagon'),
('Sport');

CREATE TABLE mobil (
    id_mobil INT AUTO_INCREMENT PRIMARY KEY,
    nama_mobil VARCHAR(100) NOT NULL,
    no_polisi VARCHAR(20) UNIQUE NOT NULL,
    tahun INT,
    warna VARCHAR(50),
    harga_sewa DECIMAL(10,2),
    STATUS ENUM('tersedia', 'disewa') DEFAULT 'tersedia',
    id_tipe INT,
    FOREIGN KEY (id_tipe) REFERENCES tipe_mobil(id_tipe)
);

INSERT INTO mobil (nama_mobil, no_polisi, tahun, warna, harga_sewa, STATUS, id_tipe) VALUES
('Toyota Fortuner', 'B1234CD', 2020, 'Hitam', 500000, 'tersedia', 1),
('Honda Civic', 'B2345DE', 2019, 'Putih', 400000, 'tersedia', 2),
('Suzuki Swift', 'B3456EF', 2018, 'Merah', 300000, 'disewa', 3),
('Toyota Avanza', 'B4567FG', 2021, 'Silver', 350000, 'tersedia', 4),
('Mazda MX-5', 'B5678GH', 2022, 'Biru', 700000, 'tersedia', 5),
('BMW M4', 'B6789HI', 2020, 'Kuning', 900000, 'tersedia', 6),
('Ford Ranger', 'B7890IJ', 2019, 'Abu-abu', 600000, 'tersedia', 7),
('Nissan Serena', 'B8901JK', 2018, 'Putih', 450000, 'disewa', 8),
('Subaru Outback', 'B9012KL', 2021, 'Hijau', 550000, 'tersedia', 9),
('Lamborghini Huracan', 'B0123LM', 2023, 'Oranye', 1500000, 'tersedia', 10);

CREATE TABLE transaksi (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan INT,
    tgl_sewa DATE,
    tgl_kembali DATE,
    total_biaya DECIMAL(12,2),
    status_transaksi ENUM('berlangsung','selesai','dibatalkan') DEFAULT 'berlangsung',
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

INSERT INTO transaksi (id_pelanggan, tgl_sewa, tgl_kembali, total_biaya, status_transaksi) VALUES
(1, '2025-04-01', '2025-04-03', 1000000, 'selesai'),
(2, '2025-04-02', '2025-04-05', 1500000, 'selesai'),
(3, '2025-04-03', '2025-04-04', 300000, 'selesai'),
(4, '2025-04-04', '2025-04-06', 700000, 'berlangsung'),
(5, '2025-04-05', '2025-04-07', 1400000, 'selesai'),
(6, '2025-04-06', '2025-04-08', 2700000, 'berlangsung'),
(7, '2025-04-07', '2025-04-09', 900000, 'selesai'),
(8, '2025-04-08', '2025-04-10', 1100000, 'dibatalkan'),
(9, '2025-04-09', '2025-04-11', 450000, 'berlangsung'),
(10, '2025-04-10', '2025-04-12', 500000, 'berlangsung');


CREATE TABLE detail_transaksi (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi INT,
    id_mobil INT,
    lama_sewa INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
    FOREIGN KEY (id_mobil) REFERENCES mobil(id_mobil)
);

INSERT INTO detail_transaksi (id_transaksi, id_mobil, lama_sewa, subtotal) VALUES
(1, 1, 2, 1000000),
(2, 2, 3, 1200000),
(3, 3, 1, 300000),
(4, 4, 2, 700000),
(5, 5, 2, 1400000),
(6, 6, 3, 2700000),
(7, 7, 2, 900000),
(8, 8, 2, 1100000),
(9, 9, 1, 450000),
(10, 1, 1, 500000);


-- View gabungan dari 2 tabel
CREATE VIEW view_transaksi_pelanggan AS
SELECT 
    t.id_transaksi,
    p.nama AS nama_pelanggan,
    t.tgl_sewa,
    t.tgl_kembali,
    t.total_biaya,
    t.status_transaksi
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan;

-- View gabungan dari minimal 3 tabel
CREATE VIEW view_detail_transaksi_lengkap AS
SELECT 
    t.id_transaksi,
    p.nama AS nama_pelanggan,
    m.nama_mobil,
    m.no_polisi,
    dt.lama_sewa,
    dt.subtotal,
    t.tgl_sewa,
    t.tgl_kembali
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.id_transaksi = dt.id_transaksi
JOIN mobil m ON dt.id_mobil = m.id_mobil;

-- View dengan syarat tertentu dari minimal 2 tabel
CREATE VIEW view_transaksi_berlangsung AS
SELECT 
    t.id_transaksi,
    p.nama AS nama_pelanggan,
    t.tgl_sewa,
    t.tgl_kembali,
    t.total_biaya
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
WHERE t.status_transaksi = 'berlangsung';

-- View dengan agregasi (SUM, COUNT, dsb.) dari minimal 2 tabel
CREATE VIEW view_total_pengeluaran_pelanggan AS
SELECT 
    p.id_pelanggan,
    p.nama AS nama_pelanggan,
    SUM(t.total_biaya) AS total_pengeluaran
FROM transaksi t
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
WHERE t.status_transaksi = 'selesai'
GROUP BY p.id_pelanggan, p.nama;


-- View bebas yang berguna dan informatif
CREATE VIEW view_ketersediaan_mobil_per_tipe AS
SELECT 
    tm.nama_tipe,
    COUNT(m.id_mobil) AS jumlah_tersedia
FROM mobil m
JOIN tipe_mobil tm ON m.id_tipe = tm.id_tipe
WHERE m.status = 'tersedia'
GROUP BY tm.nama_tipe;
