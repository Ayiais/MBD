create user 'ayiroom'@'localhost' identified by 'ayi3105';
grant all privileges on maanajemen.* to 'ayiroom'@'localhost';
FLUSH privileges;

create database if not exists maanajemen;
use maanajemen;

-- tabel 
create table users(
	user_id int primary key auto_increment,
	username varchar(255) unique not null,
	email varchar(255) unique not null,
	password_user varchar(255) not null,
	is_role boolean not null
);


create table project (
	project_id int primary key auto_increment,
	user_id int not null,
	title varchar(255) unique not null,
	deskripsi varchar(255) not null,
	status_project enum ('Belum Diambil', 'Dalam Proses', 'Selesai', 'Dibatalkan') not null default 'belum diambil',
	anggaran decimal (10, 2) not null,
	tanggal_project date not null,
	foreign key (user_id) references users (user_id) on delete cascade

);

create table penawaran(
	penawaran_id int primary key auto_increment,
	project_id int not null,
	user_id int not null,
	banding_penawaran decimal (10,2) not null,
	deskripsi_penawaran varchar(255) not null,
	tanggal_penawaran date not null,
	status_penawaran enum ('Menunggu', 'Diterima', 'Ditolak') not null default 'Menunggu',
	foreign key (project_id) references project(project_id) ON DELETE CASCADE,
	foreign key (user_id) references users (user_id) ON DELETE CASCADE,
	unique (user_id, project_id)
);

create table feedback (
    feedback_id int primary key auto_increment,
    project_id int not null,
    user_id int not null, 
    rating int check (rating >= 1 and rating <= 5),
    komentar varchar(100) not null,
    tanggal_feedback date not null,
    foreign key (project_id) references project (project_id) on delete cascade,
    foreign key (user_id) references users (user_id) on delete cascade
);


create table pembayaran (
    pembayaran_id int primary key auto_increment,
    project_id int not null, 
    tanggal_pembayaran date not null,
    jumlah_pembayaran decimal(10,2) not null,
    status_pembayaran enum('Dibayar', 'Belum Dibayar', 'Dibatalkan') not null default 'Belum Dibayar',
    foreign key (project_id) references project (project_id) on delete cascade
);


create table laporan (
    laporan_id int primary key auto_increment,
    project_id int not null,
    user_id int not null, 
    deskripsi_laporan varchar(255) not null,
    tanggal_laporan date not null,
    hasil_project enum('Selesai', 'Dalam Proses', 'Gagal') not null default 'Dalam Proses',
    foreign key (project_id) references project (project_id) on delete cascade,
    foreign key (user_id) references users (user_id) on delete cascade
);

-- procedure register ------------------
-- ------------------------------------
delimiter $$
create procedure register(
	in _username varchar (255),
	in _email varchar(255),
	in _password_user varchar(255),
	in _is_role boolean
)
begin 
	declare exit handler for sqlexception 
	begin 
		rollback;
		resignal;
	end;

	start transaction;

	if (_username is null or length(_username) < 3) then 
        signal sqlstate '45000' set message_text =  'panjang username minimal 3';
    end if;

	if (_password_user is null or length(_password_user) < 8) then
    	signal sqlstate '45000' set message_text =  'panjang password minimal 8';
	end if;

	
	insert into users
	set 
		users.username = _username,
		users.email = _email,
		users.password_user = sha2(_password_user, 256),
		users.is_role = _is_role;
	commit;
	
end $$


-- procedure login ----------------------------------------
-- --------------------------------------------------------
create procedure login(
	in _username varchar(255),
	in _password_user varchar(255)
)
begin 
	
	declare _user_id int;

	declare exit handler for sqlexception 
	begin 
		rollback;
		resignal;
	end;
	
	start transaction;

	if (_username is null or length(_username) < 3) 
		then signal sqlstate '45000' set message_text =  'panjang username minimal 3';
	end if;

	if (_password_user is null or length(_password_user) < 8) 
		then signal sqlstate '45000' set message_text =  'panjang password minimal 8';
	end if;

	if not exists(
		select 1
		from users
		where username = _username and password_user = sha2(_password_user,256)
	) then 
		signal sqlstate  '45000' set message_text = 'username atau password salah';
	end if;

	select
		user_id, username, email, password_user, is_role
	from users
	where 
		username = _username and password_user = sha2(_password_user, 256);
	
	commit;

end $$

delimiter ;

-- procedure CRUD project ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
delimiter $$
create procedure add_project(
    in _title varchar(255),
    in _deskripsi varchar(255),
    in _status_project enum('Belum Diambil', 'Dalam Proses', 'Selesai', 'Dibatalkan'),
    in _anggaran decimal(10,2),
    in _tanggal_project date,
    in _username varchar(255)
)
begin
    
    declare _user_id int;

    
    declare exit handler for sqlexception
    begin
        rollback;  
        signal sqlstate '45000' set message_text = 'Terjadi kesalahan dalam transaksi';
    end;

    start transaction; 
   
    if not exists(select 1 from users where username = _username and is_role = false) then
        signal sqlstate '45000' set message_text = 'Hanya klien yang dapat menambahkan project';
    end if;

    if (_title is null or length(_title) < 1) then 
        signal sqlstate '45000' set message_text = 'Judul project tidak boleh kosong';
    end if;

    if (_deskripsi is null or length(_deskripsi) < 1) then 
        signal sqlstate '45000' set message_text = 'Deskripsi project tidak boleh kosong';
    end if;

    if (_anggaran is null or _anggaran <= 0) then 
        signal sqlstate '45000' set message_text = 'Anggaran project harus lebih dari 0';
    end if;

    if (_tanggal_project is null) then 
        signal sqlstate '45000' set message_text = 'Tanggal project tidak boleh kosong';
    end if;

    select user_id into _user_id
    from users
    where username = _username and is_role = false;

    insert into project 
    set
    	user_id = _user_id,
        title = _title,
        deskripsi = _deskripsi,
        status_project = _status_project,
        anggaran = _anggaran,
        tanggal_project = _tanggal_project;
    
    select 
    	project_id, title, deskripsi, status_project, anggaran, tanggal_project
    from project 
    where title = _title and deskripsi= _deskripsi and anggaran = _anggaran;
    
    commit; 
   
end $$

delimiter ;

delimiter $$
CREATE VIEW v_projects AS
SELECT 
    project_id, 
    title, 
    deskripsi, 
    status_project, 
    anggaran, 
    tanggal_project
FROM project;

delimiter ;

-- --------------------
delimiter $$
create procedure update_project(
    in _old_title varchar(255),         
    in _new_title varchar(255),         
    in _deskripsi varchar(255),
    in _status_project enum('Belum Diambil', 'Dalam Proses', 'Selesai', 'Dibatalkan'),
    in _anggaran decimal(10,2),
    in _tanggal_project date           
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    if not exists(select 1 from project where title = _old_title) then
        signal sqlstate '45000' set message_text = 'Project dengan title tersebut tidak ditemukan';
    end if;

    if (_deskripsi is null or length(_deskripsi) < 1) then
        signal sqlstate '45000' set message_text = 'Deskripsi project tidak boleh kosong';
    end if;

    if (_anggaran is null or _anggaran <= 0) then
        signal sqlstate '45000' set message_text = 'Anggaran project harus lebih dari 0';
    end if;

    if (_tanggal_project is null) then
        signal sqlstate '45000' set message_text = 'Tanggal project tidak boleh kosong';
    end if;

    update project
    set 
        project.title = _new_title,              
        project.deskripsi = _deskripsi,
        project.status_project = _status_project,
        project.anggaran = _anggaran,
        project.tanggal_project = _tanggal_project
    where title = _old_title;            

    commit;

end $$

delimiter ;
-- ----------------------------------------------
delimiter $$
create procedure delete_project_by_title(
    in _title varchar(255)
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    if not exists(select 1 from project where title = _title) then
        signal sqlstate '45000' set message_text = 'Project dengan title tersebut tidak ditemukan';
    end if;

    delete from project where title = _title;

    commit;

end $$

delimiter ;

delimiter $$
create procedure read_project(
    in _title varchar(255)
)
begin
    -- Jika judul proyek tidak diberikan, tampilkan semua proyek
    if _title is null then
        select 
            project_id, 
            title, 
            deskripsi, 
            status_project, 
            anggaran, 
            tanggal_project
        from project;
    else
        -- Jika judul proyek diberikan, tampilkan proyek dengan judul tersebut
        if not exists(select 1 from project where title = _title) then
            signal sqlstate '45000' set message_text = 'Project dengan title tersebut tidak ditemukan';
        end if;

        select 
            project_id, 
            title, 
            deskripsi, 
            status_project, 
            anggaran, 
            tanggal_project
        from project_view 
        where title = _title;
    end if;
end $$

delimiter ;

DELIMITER $$

CREATE VIEW project_view AS
SELECT 
    project_id, 
    title, 
    deskripsi, 
    status_project, 
    anggaran, 
    tanggal_project
FROM project;

DELIMITER ;

-- procedure CRUD project ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- procedure CRUD penawaran ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
delimiter $$

create procedure add_penawaran(
    in _username varchar(255),
    in _project_title varchar(255),
    in _banding_penawaran decimal(10,2),
    in _deskripsi_penawaran varchar(255),
    in _tanggal_penawaran date,
    in _status_penawaran varchar(50)
)
begin
    declare _user_id int;
    declare _project_id int;

    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    -- Cek apakah user adalah freelancer
    select user_id into _user_id 
    from users 
    where username = _username and is_role = true;

    if not exists(select 1 from users where username = _username and is_role = true) then 
        signal sqlstate '45000' set message_text = 'Hanya freelancer yang dapat menambahkan penawaran';
    end if;

    -- Cek apakah _user_id ditemukan
    if _user_id is null then
        signal sqlstate '45000' set message_text = 'Username tidak valid';
    end if;

    -- Ambil project_id dari judul project
    select project_id into _project_id 
    from project 
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Project tidak ditemukan';
    end if;

    -- Cek jika sudah ada penawaran dari freelancer untuk project ini
    if exists(select 1 from penawaran where project_id = _project_id and user_id = _user_id) then
        signal sqlstate '45000' set message_text = 'Penawaran untuk project ini sudah ada dari freelancer';
    end if;

    -- Cek status project
    if exists(select 1 from project where project_id = _project_id and status_project in ('Selesai', 'Dibatalkan')) then
        signal sqlstate '45000' set message_text = 'Penawaran tidak dapat dibuat untuk project yang telah selesai atau dibatalkan';
    end if;

    -- Cek apakah banding penawaran valid
    if (_banding_penawaran <= 0) then
        signal sqlstate '45000' set message_text = 'Banding penawaran harus lebih dari 0';
    end if;

    -- Insert data penawaran
    insert into penawaran 
    set
        project_id = _project_id,
        user_id = _user_id,
        banding_penawaran = _banding_penawaran,
        deskripsi_penawaran = _deskripsi_penawaran,
        tanggal_penawaran = _tanggal_penawaran,
        status_penawaran = _status_penawaran;

    -- Menampilkan hasil penawaran yang baru ditambahkan
    select 
        penawaran_id, project_id, user_id, banding_penawaran, deskripsi_penawaran, tanggal_penawaran, status_penawaran
    from penawaran 
    where 
        project_id = _project_id and user_id = _user_id; 

    commit;
end $$

delimiter ;


delimiter $$
create procedure delete_penawaran_by_project(
    in _project_title varchar(255)
)
begin
    declare _project_id int;

    -- Menangani error dalam transaksi
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    -- Validasi apakah project dengan title yang diberikan ada
    select project_id into _project_id
    from project
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Project dengan nama tersebut tidak ditemukan';
    end if;

    -- Validasi apakah ada penawaran terkait project tersebut
    if not exists(select 1 from penawaran where project_id = _project_id) then
        signal sqlstate '45000' set message_text = 'Tidak ada penawaran terkait project tersebut';
    end if;

    -- Hapus penawaran terkait project tersebut
    delete from penawaran where project_id = _project_id;

    commit;
end $$
delimiter ;

delimiter $$
create procedure accept_penawaran_by_project(
    in _nama_project varchar(255)
)
begin
    declare _project_id int;
    declare _penawaran_id int;

    -- Menangani error dalam transaksi
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;

    -- Validasi apakah project ada
    select project_id into _project_id
    from project
    where title = _nama_project;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Project dengan nama tersebut tidak ditemukan';
    end if;

    -- Validasi apakah penawaran untuk project ada
    select penawaran_id into _penawaran_id
    from penawaran
    where project_id = _project_id and status_penawaran = 'Menunggu'
    limit 1;

    if _penawaran_id is null then
        signal sqlstate '45000' set message_text = 'Tidak ada penawaran yang dapat diterima untuk project ini';
    end if;

    -- Validasi apakah project sudah memiliki penawaran diterima
    if exists(
        select 1
        from penawaran
        where project_id = _project_id and status_penawaran = 'Diterima'
    ) then
        signal sqlstate '45000' set message_text = 'Project ini sudah memiliki penawaran diterima';
    end if;

    -- Update status penawaran menjadi 'Diterima'
    update penawaran
    set status_penawaran = 'Diterima'
    where penawaran_id = _penawaran_id;

    -- Update status project menjadi 'Dalam Proses'
    update project
    set status_project = 'Dalam Proses'
    where project_id = _project_id;
   
     select * from project_penawaran_status_view
     where project_id = _project_id;

    commit;
end $$
delimiter ;

delimiter $$
create view project_penawaran_status_view as
select 
    p.project_id, 
    p.title as project_title,
    p.status_project, 
    p.tanggal_project, 
    pe.penawaran_id, 
    pe.user_id as freelancer_id, 
    pe.banding_penawaran, 
    pe.deskripsi_penawaran, 
    pe.tanggal_penawaran, 
    pe.status_penawaran
from project p
join penawaran pe on p.project_id = pe.project_id;
delimiter ;

delimiter $$
create procedure read_all_penawaran()
begin
    -- Menampilkan seluruh data dari tabel penawaran
    select 
        p.penawaran_id,
        p.banding_penawaran,
        p.deskripsi_penawaran,
        p.tanggal_penawaran,
        p.status_penawaran,
        u.username as nama_user,
        pr.title as nama_project
    from 
        penawaran p
    join 
        users u on p.user_id = u.user_id -- Menghubungkan dengan tabel users
    join 
        project pr on p.project_id = pr.project_id; -- Menghubungkan dengan tabel project
end $$
delimiter ;



-- procedure CRUD penawaran ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- procedure CRUD feedback ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
delimiter $$

create procedure add_feedback(
    in _username_client varchar(255),
    in _username_freelancer varchar(255),
    in _nama_proyek varchar(255),
    in _komentar varchar(255),
    in _rating int
)
begin
    declare _client_id int;
    declare _freelancer_id int;
    declare _project_id int;

    -- Memastikan username client valid dan mendapatkan client_id
    select user_id into _client_id 
    from users 
    where username = _username_client and is_role = false;
    
    if _client_id is null then
        signal sqlstate '45000' set message_text = 'Client tidak ditemukan atau bukan klien';
    end if;

    -- Memastikan username freelancer valid dan mendapatkan freelancer_id
    select user_id into _freelancer_id 
    from users 
    where username = _username_freelancer and is_role = true;
    
    if _freelancer_id is null then
        signal sqlstate '45000' set message_text = 'Freelancer tidak ditemukan atau bukan freelancer';
    end if;

    -- Memastikan proyek klien sudah selesai berdasarkan nama proyek
    select project_id into _project_id 
    from project 
    where user_id = _client_id and status_project = 'Selesai' and title = _nama_proyek
    limit 1;
    
    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek belum selesai atau nama proyek tidak ditemukan';
    end if;

    -- Memastikan rating dalam batas yang benar
    if _rating < 1 or _rating > 5 then
        signal sqlstate '45000' set message_text = 'Rating harus antara 1 dan 5';
    end if;

    -- Menyisipkan feedback
   insert into feedback
    set 
        project_id = _project_id,
        user_id = _freelancer_id,
        rating = _rating,
        komentar = _komentar,
        tanggal_feedback = current_date;
       
   select * from v_feedback;

end $$
delimiter ;

delimiter $$

create view v_feedback AS
select 
    f.feedback_id,
    p.title as nama_proyek,
    u_client.username as nama_client,
    u_freelancer.username as nama_freelancer,
    f.rating,
    f.komentar,
    f.tanggal_feedback
from 
    feedback f
join 
    users u_client on f.user_id = u_client.user_id and u_client.is_role = false  -- Klien
join 
    users u_freelancer on f.user_id = u_freelancer.user_id and u_freelancer.is_role = true  -- Freelancer
join 
    project p on f.project_id = p.project_id;  -- Project
     
delimiter ;

delimiter $$

create procedure delete_feedback(
    in _username_client varchar(255),
    in _username_freelancer varchar(255),
    in _project_title varchar(255)
)
begin
    declare _client_id int;
    declare _freelancer_id int;
    declare _project_id int;

    -- mendapatkan client_id berdasarkan username client
    select user_id into _client_id
    from users
    where username = _username_client and is_role = false;

    if _client_id is null then
        signal sqlstate '45000' set message_text = 'client tidak ditemukan atau bukan klien';
    end if;

    -- mendapatkan freelancer_id berdasarkan username freelancer
    select user_id into _freelancer_id
    from users
    where username = _username_freelancer and is_role = true;

    if _freelancer_id is null then
        signal sqlstate '45000' set message_text = 'freelancer tidak ditemukan atau bukan freelancer';
    end if;

    -- mendapatkan project_id berdasarkan project_title dan client_id
    select project_id into _project_id
    from project
    where user_id = _client_id and title = _project_title and status_project = 'selesai';

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'proyek tidak ditemukan atau belum selesai';
    end if;

    -- menghapus feedback berdasarkan project_id dan freelancer_id
    delete from feedback
    where project_id = _project_id and user_id = _freelancer_id;

    -- memastikan feedback berhasil dihapus
    if row_count() = 0 then
        signal sqlstate '45000' set message_text = 'feedback tidak ditemukan';
    end if;

end $$

delimiter ;

delimiter $$

create procedure read_feedback(
    in _username_client varchar(255),
    in _username_freelancer varchar(255),
    in _project_title varchar(255)
)
begin
    declare _client_id int;
    declare _freelancer_id int;
    declare _project_id int;

    -- mendapatkan client_id berdasarkan username client
    select user_id into _client_id
    from users
    where username = _username_client and is_role = false;

    if _client_id is null then
        signal sqlstate '45000' set message_text = 'client tidak ditemukan atau bukan klien';
    end if;

    -- mendapatkan freelancer_id berdasarkan username freelancer
    select user_id into _freelancer_id
    from users
    where username = _username_freelancer and is_role = true;

    if _freelancer_id is null then
        signal sqlstate '45000' set message_text = 'freelancer tidak ditemukan atau bukan freelancer';
    end if;

    -- mendapatkan project_id berdasarkan project_title dan client_id
    select project_id into _project_id
    from project
    where user_id = _client_id and title = _project_title and status_project = 'selesai';

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'proyek tidak ditemukan atau belum selesai';
    end if;

    -- menampilkan feedback terkait proyek dan freelancer
    select feedback_id, komentar, rating, tanggal_feedback
    from feedback
    where project_id = _project_id and user_id = _freelancer_id;

end $$

delimiter ;

delimiter $$

create procedure update_feedback(
    in _username_client varchar(255),
    in _username_freelancer varchar(255),
    in _project_title varchar(255),
    in _new_komentar varchar(255),
    in _new_rating int
)
begin
    declare _client_id int;
    declare _freelancer_id int;
    declare _project_id int;

    -- mendapatkan client_id berdasarkan username client
    select user_id into _client_id
    from users
    where username = _username_client and is_role = false;

    if _client_id is null then
        signal sqlstate '45000' set message_text = 'client tidak ditemukan atau bukan klien';
    end if;

    -- mendapatkan freelancer_id berdasarkan username freelancer
    select user_id into _freelancer_id
    from users
    where username = _username_freelancer and is_role = true;

    if _freelancer_id is null then
        signal sqlstate '45000' set message_text = 'freelancer tidak ditemukan atau bukan freelancer';
    end if;

    -- mendapatkan project_id berdasarkan project_title dan client_id
    select project_id into _project_id
    from project
    where user_id = _client_id and title = _project_title and status_project = 'selesai';

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'proyek tidak ditemukan atau belum selesai';
    end if;

    -- memastikan rating dalam batas yang benar
    if _new_rating < 1 or _new_rating > 5 then
        signal sqlstate '45000' set message_text = 'rating harus antara 1 dan 5';
    end if;

    -- memastikan feedback terkait proyek dan freelancer ada
    if not exists (
        select 1 
        from feedback
        where project_id = _project_id and user_id = _freelancer_id
    ) then
        signal sqlstate '45000' set message_text = 'feedback tidak ditemukan';
    end if;

    -- memperbarui komentar dan/atau rating pada feedback
    update feedback
    set 
        komentar = _new_komentar,
        rating = _new_rating,
        tanggal_feedback = current_date
    where project_id = _project_id and user_id = _freelancer_id;

end $$

delimiter ;


-- procedure CRUD feedback ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
-- procedure CRUD laporan ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
delimiter $$

create procedure add_laporan(
    in _project_title varchar(255),
    in _user_name varchar(255),
    in _deskripsi_laporan varchar(255),
    in _tanggal_laporan date,
    in _hasil_project enum('Selesai', 'Dalam Proses', 'Gagal')
)
begin
    declare _project_id int;
    declare _user_id int;

    -- Mendapatkan project_id berdasarkan nama proyek
    select project_id into _project_id
    from project
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan.';
    end if;

    -- Mendapatkan user_id berdasarkan nama pengguna
    select user_id into _user_id
    from users
    where username = _user_name;

    if _user_id is null then
        signal sqlstate '45000' set message_text = 'Pengguna tidak ditemukan.';
    end if;

    -- Menyisipkan laporan
    insert into laporan (project_id, user_id, deskripsi_laporan, tanggal_laporan, hasil_project)
    values (_project_id, _user_id, _deskripsi_laporan, _tanggal_laporan, _hasil_project);
end $$

delimiter ;

DELIMITER $$

CREATE PROCEDURE update_project_to_completed(
    IN _project_name VARCHAR(255)
)
BEGIN
    DECLARE _project_id INT;

    -- Memastikan proyek dengan nama yang diberikan ada dalam status "Dalam Proses"
    SELECT project_id INTO _project_id 
    FROM project 
    WHERE title = _project_name AND status_project = 'Dalam Proses';

    IF _project_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proyek tidak ditemukan atau status proyek bukan "Dalam Proses".';
    END IF;

    -- Mengubah status proyek menjadi "Selesai"
    UPDATE project
    SET status_project = 'Selesai'
    WHERE project_id = _project_id;

    COMMIT;

END $$

DELIMITER ;

delimiter $$

create procedure delete_laporan(
    in _project_title varchar(255),
    in _user_name varchar(255)
)
begin
    declare _project_id int;
    declare _user_id int;

    -- Mendapatkan project_id berdasarkan nama proyek
    select project_id into _project_id
    from project
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan.';
    end if;

    -- Mendapatkan user_id berdasarkan nama pengguna
    select user_id into _user_id
    from users
    where username = _user_name;

    if _user_id is null then
        signal sqlstate '45000' set message_text = 'Pengguna tidak ditemukan.';
    end if;

    -- Menghapus laporan
    delete from laporan
    where project_id = _project_id and user_id = _user_id;
end $$

delimiter ;

delimiter $$

create procedure read_laporan(
    in _project_title varchar(255),
    in _user_name varchar(255)
)
begin
    declare _project_id int;
    declare _user_id int;

    -- Mendapatkan project_id berdasarkan nama proyek
    select project_id into _project_id
    from project
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan.';
    end if;

    -- Mendapatkan user_id berdasarkan nama pengguna
    select user_id into _user_id
    from users
    where username = _user_name;

    if _user_id is null then
        signal sqlstate '45000' set message_text = 'Pengguna tidak ditemukan.';
    end if;

    -- Membaca laporan
    select laporan_id, project_id, user_id, deskripsi_laporan, tanggal_laporan, hasil_project
    from laporan
    where project_id = _project_id and user_id = _user_id;
end $$

delimiter ;

delimiter $$

create procedure update_laporan(
    in _project_title varchar(255),
    in _user_name varchar(255),
    in _deskripsi_laporan varchar(255),
    in _hasil_project enum('Selesai', 'Dalam Proses', 'Gagal')
)
begin
    declare _project_id int;
    declare _user_id int;

    -- Mendapatkan project_id berdasarkan nama proyek
    select project_id into _project_id
    from project
    where title = _project_title;

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan.';
    end if;

    -- Mendapatkan user_id berdasarkan nama pengguna
    select user_id into _user_id
    from users
    where username = _user_name;

    if _user_id is null then
        signal sqlstate '45000' set message_text = 'Pengguna tidak ditemukan.';
    end if;

    -- Memperbarui laporan
    update laporan
    set deskripsi_laporan = _deskripsi_laporan,
        hasil_project = _hasil_project
    where project_id = _project_id and user_id = _user_id;
end $$

delimiter ;

-- procedure CRUD laporan ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- procedure CRUD pembayaran ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
delimiter $$

create procedure create_pembayaran(
    in _username_client varchar(255),
    in _project_title varchar(255),
    in _jumlah_pembayaran decimal(10,2)
)
begin
    declare _client_id int;
    declare _project_id int;

    -- Validasi klien
    select user_id into _client_id
    from users
    where username = _username_client and is_role = false;

    if _client_id is null then
        signal sqlstate '45000' set message_text = 'Client tidak ditemukan atau bukan klien';
    end if;

    -- Validasi proyek
    select project_id into _project_id
    from project
    where user_id = _client_id and title = _project_title and status_project = 'Selesai';

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan atau belum selesai';
    end if;

    -- Menambahkan pembayaran
    insert into pembayaran
    set 
        project_id = _project_id,
        tanggal_pembayaran = current_date,
        jumlah_pembayaran = _jumlah_pembayaran,
        status_pembayaran = "Dibayar";
end $$
delimiter ;

delimiter $$

create procedure read_pembayaran(
    in _username_client varchar(255)
)
begin
    if _username_client is null then
        -- Jika username_client tidak diberikan, tampilkan semua data
        select 
            pembayaran_id, 
            project_id, 
            tanggal_pembayaran, 
            jumlah_pembayaran, 
            status_pembayaran
        from pembayaran;
    else
        -- Jika username_client diberikan, tampilkan data berdasarkan klien tersebut
        select 
            p.pembayaran_id, 
            p.project_id, 
            p.tanggal_pembayaran, 
            p.jumlah_pembayaran, 
            p.status_pembayaran
        from pembayaran p
        join project pr on p.project_id = pr.project_id
        join users u on pr.user_id = u.user_id
        where u.username = _username_client;
    end if;
end $$

delimiter ;


delimiter $$
create procedure delete_pembayaran(
    in _project_title varchar(255),
    in _tanggal_pembayaran date
)
begin
    declare _project_id int;

    -- Validasi keberadaan proyek
    set _project_id = (
        select project_id
        from project
        where title = _project_title
        limit 1
    );

    if _project_id is null then
        signal sqlstate '45000' set message_text = 'Proyek tidak ditemukan';
    end if;

    -- Validasi keberadaan pembayaran
    if not exists (
        select 1 
        from pembayaran 
        where project_id = _project_id and tanggal_pembayaran = _tanggal_pembayaran
    ) then
        signal sqlstate '45000' set message_text = 'Pembayaran tidak ditemukan';
    end if;

    -- Hapus pembayaran
    delete from pembayaran
    where project_id = _project_id and tanggal_pembayaran = _tanggal_pembayaran;
end $$

delimiter ;


-- procedure CRUD pembayaran ----------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- FUNCTIONS
delimiter $$

create function average_feedback_rating(
    _project_title varchar(255)
) 
returns decimal(3, 2)
deterministic
reads sql data
begin
    declare _project_id int;
    declare _average_rating decimal(3, 2);

    -- Cari project_id berdasarkan title proyek
    select project_id into _project_id
    from project
    where title = _project_title
    limit 1;

    -- Hitung rata-rata rating untuk proyek tersebut
    select avg(rating) into _average_rating
    from feedback
    where project_id = _project_id;

    -- Jika tidak ada feedback, set rating rata-rata menjadi 0
    if _average_rating is null then
        set _average_rating = 0;
    end if;

    return _average_rating;
    
end $$

delimiter ;


delimiter $$

create procedure get_average_rating_procedure(
    in _project_title varchar(255)
)
begin
    declare _avg_rating decimal(3,2);

    -- Memulai transaksi
    start transaction;

    -- Panggil fungsi untuk mendapatkan rata-rata rating
    set _avg_rating = average_feedback_rating(_project_title);  -- Menggunakan nama fungsi yang benar

    -- Menampilkan hasil
    select _avg_rating as average_rating;

    -- Commit transaksi
    commit;
end $$

delimiter ;


-- ------------------------------
delimiter $$

create function check_payment_status(
    _project_title varchar(255)
) 
returns varchar(255)
deterministic
reads sql data
begin
    declare _project_id int;
    declare _status_pembayaran varchar(255);

    -- Cari project_id berdasarkan title proyek
    select project_id into _project_id
    from project
    where title = _project_title
    limit 1;

    -- Cek status pembayaran berdasarkan project_id
    select status_pembayaran into _status_pembayaran
    from pembayaran
    where project_id = _project_id
    order by tanggal_pembayaran desc
    limit 1;

    -- Jika tidak ada status pembayaran, kembalikan status default
    if _status_pembayaran is null then
        set _status_pembayaran = 'Belum Dibayar';
    end if;

    return _status_pembayaran;
end $$

delimiter ;


delimiter $$

create procedure check_payment_status_procedure(
    in _project_title varchar(255)
)
begin
    declare _status_pembayaran varchar(255);

    -- Memulai transaksi
    start transaction;

    -- Panggil function untuk mendapatkan status pembayaran
    set _status_pembayaran = check_payment_status(_project_title);

    -- Menampilkan hasil
    select _status_pembayaran as payment_status;

    -- Commit transaksi
    commit;
end $$

delimiter ;

-- ----------------------

delimiter $$

create function get_total_pembayaran(
    _project_title varchar(255)
) 
returns decimal(10,2)
deterministic
reads sql data
begin
    declare _project_id int;
    declare _total_pembayaran decimal(10,2);

    -- Cari project_id berdasarkan title proyek
    select project_id into _project_id
    from project
    where title = _project_title
    limit 1;

    -- Hitung total pembayaran untuk proyek tersebut
    select sum(jumlah_pembayaran) into _total_pembayaran
    from pembayaran
    where project_id = _project_id;

    -- Jika tidak ada pembayaran, kembalikan 0
    if _total_pembayaran is null then
        set _total_pembayaran = 0.00;
    end if;

    return _total_pembayaran;
end $$

delimiter ;


delimiter $$

create procedure get_project_total_payment(
    in _project_title varchar(255)
)
begin
    declare _total_pembayaran decimal(10,2);

    -- Memulai transaksi
    start transaction;

    -- Panggil function untuk mendapatkan total pembayaran
    set _total_pembayaran = get_total_pembayaran(_project_title);

    -- Tampilkan hasil
    select _total_pembayaran as total_pembayaran;

    -- Commit transaksi
    commit;
end $$

delimiter ;

-- -----------------------------
delimiter $$

create function current_offer_status(
    _project_title varchar(255)
) 
returns varchar(255)
deterministic
reads sql data
begin
    declare _project_id int;
    declare _offer_status varchar(255);

    -- Cari project_id berdasarkan title proyek
    select project_id into _project_id
    from project
    where title = _project_title
    limit 1;

    -- Cari status penawaran terbaru untuk proyek tersebut
    select status_penawaran into _offer_status
    from penawaran
    where project_id = _project_id
    order by tanggal_penawaran desc
    limit 1;

    -- Jika tidak ada penawaran, set status menjadi 'Tidak Ada Penawaran'
    if _offer_status is null then
        set _offer_status = 'Tidak Ada Penawaran';
    end if;

    return _offer_status;
end $$

delimiter ;


delimiter $$

create procedure get_current_offer_status(
    in _project_title varchar(255)
)
begin
    declare _offer_status varchar(255);

    -- Memulai transaksi
    start transaction;

    -- Panggil function untuk mendapatkan status penawaran terkini untuk proyek
    set _offer_status = current_offer_status(_project_title);

    -- Tampilkan hasil
    select _offer_status as status_penawaran_terkini;

    -- Commit transaksi
    commit;
end $$

delimiter ;


delimiter $$

create trigger update_offer_status
after insert on penawaran
for each row
begin
    declare _offer_status varchar(255);

    -- Ambil status penawaran terbaru untuk project yang bersangkutan
    select status_penawaran into _offer_status
    from penawaran
    where project_id = new.project_id
    order by tanggal_penawaran desc
    limit 1;

    -- Perbarui status_penawaran di tabel project
    update project
    set status_penawaran = _offer_status
    where project_id = new.project_id;
end $$

delimiter ;


delimiter $$

create trigger update_project_total_payment
after insert on pembayaran
for each row
begin
    declare _total_pembayaran decimal(10,2);

    -- Hitung total pembayaran untuk project_id yang terkait
    select sum(jumlah_pembayaran) into _total_pembayaran
    from pembayaran
    where project_id = new.project_id;

    -- Perbarui total_pembayaran di tabel project
    update project
    set total_pembayaran = _total_pembayaran
    where project_id = new.project_id;
end $$

delimiter ;


delimiter $$

create trigger update_average_rating_after_feedback_deleted
after delete on feedback
for each row
begin
    declare _average_rating decimal(3,2);

    -- Hitung rata-rata rating setelah feedback dihapus
    select avg(rating) into _average_rating
    from feedback
    where project_id = old.project_id;

    -- Jika tidak ada feedback, set rata-rata menjadi 0
    if _average_rating is null then
        set _average_rating = 0;
    end if;

    -- Perbarui rata-rata rating di tabel project
    update project
    set average_rating = _average_rating
    where project_id = old.project_id;
end $$

delimiter ;


delimiter $$

create trigger update_status_after_payment_deleted
after delete on pembayaran
for each row
begin
    declare _status_pembayaran varchar(255);

    -- Ambil status pembayaran terbaru untuk project setelah pembayaran dihapus
    select status_pembayaran into _status_pembayaran
    from pembayaran
    where project_id = old.project_id
    order by tanggal_pembayaran desc
    limit 1;

    -- Jika tidak ada pembayaran, set status ke 'Belum Dibayar'
    if _status_pembayaran is null then
        set _status_pembayaran = 'Belum Dibayar';
    end if;

    -- Perbarui status_pembayaran di tabel project
    update project
    set status_pembayaran = _status_pembayaran
    where project_id = old.project_id;
end $$

delimiter ;

-- --------------------------------------------------------------------------------------------
-- testing
call register('Zelielie Anna', 'ZelielieAnnna@example.com', 'zelielie123', true);
call register('Lattema Lie','LatteLatte@example.com','12345678', false);
call login('Zelielie Anna', 'zelielie123');
-- -- 
call add_project('Proyek Website Baru','Membangun website untuk toko online','Belum Diambil', 5000000.00,'2024-11-25','Lattema Lie');
-- call update_project('Proyek Website Baru','Proyek Website new','Membangun website toko online','Dalam Proses',10000000.00,'2024-12-01');
-- -- call read_project(null);
-- -- call read_project('Proyek Website new');
-- -- call delete_project_by_title('Proyek Website new');
-- 
-- -- 
call add_penawaran('Zelielie Anna', 'Proyek Website Baru', 4500000.00,'Penawaran baru untuk harga yang lebih murah','2024-11-26','Menunggu');
-- -- call delete_penawaran_by_project('Proyek Website new');
-- call accept_penawaran_by_project('Proyek Website Baru');
-- call read_all_penawaran();
-- -- 
-- call update_project_to_completed('Proyek Website new');
-- call add_feedback('Lattema Lie', 'Zelielie Anna', 'Proyek Website new', 'Sangat memuaskan, kerja bagus!', 5);
-- -- call delete_feedback('Lattema Lie', 'Zelielie Anna', 'Proyek Website new');
-- call read_feedback('Lattema Lie', 'Zelielie Anna', 'Proyek Website new');
-- -- call update_feedback('Lattema Lie', 'Zelielie Anna', 'Proyek Website new', 'Hasil kerja sangat memuaskan, rekomendasi untuk proyek lain!', 5);
-- -- 
-- call add_laporan('Proyek Website new', 'Lattema Lie', 'Laporan tentang proyek ini', '2024-12-07', 'Selesai');
-- -- call delete_laporan('Proyek Website new', 'Lattema Lie');
-- -- call read_laporan('Proyek Website new', 'Lattema Lie');
-- -- call update_laporan('Proyek Website new', 'Lattema Lie', 'Laporan revisi', 'Dalam Proses');
-- -- 
-- call create_pembayaran('Lattema Lie', 'Proyek Website new', 500000.00);
-- call delete_pembayaran('Project 123', '2024-12-09');
-- call read_pembayaran(null);
-- call read_pembayaran('Lattema Lie');
-- 

SELECT user, host FROM mysql.user;
-- DROP USER 'ayiroom'@'localhost';
-- -- 
-- SHOW GRANTS FOR 'ayi_freelancer'@'localhost';

-- CALL register('Ayiiii alipah', 'ayialipaaaaah@example.com', '12345678910', true);

-- delete from penawaran;




