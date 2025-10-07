import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GymApp());
}

// ----------------------- MODELS -----------------------
class Member {
  int? id;
  String name;
  String phone;
  String email;
  String plan;
  DateTime joinedAt;

  Member({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.plan,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'plan': plan,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory Member.fromMap(Map<String, dynamic> m) => Member(
        id: m['id'] as int?,
        name: m['name'] as String,
        phone: m['phone'] as String,
        email: m['email'] as String,
        plan: m['plan'] as String,
        joinedAt: DateTime.parse(m['joinedAt'] as String),
      );
}

class Payment {
  int? id;
  int memberId;
  double amount;
  DateTime paidAt;
  String note;

  Payment({
    this.id,
    required this.memberId,
    required this.amount,
    DateTime? paidAt,
    this.note = '',
  }) : paidAt = paidAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'memberId': memberId,
        'amount': amount,
        'paidAt': paidAt.toIso8601String(),
        'note': note,
      };

  factory Payment.fromMap(Map<String, dynamic> m) => Payment(
        id: m['id'] as int?,
        memberId: m['memberId'] as int,
        amount: (m['amount'] as num).toDouble(),
        paidAt: DateTime.parse(m['paidAt'] as String),
        note: (m['note'] ?? '') as String,
      );
}

class Attendance {
  int? id;
  int memberId;
  DateTime time;

  Attendance({
    this.id,
    required this.memberId,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'memberId': memberId,
        'time': time.toIso8601String(),
      };

  factory Attendance.fromMap(Map<String, dynamic> m) => Attendance(
        id: m['id'] as int?,
        memberId: m['memberId'] as int,
        time: DateTime.parse(m['time'] as String),
      );
}

// ----------------------- DATABASE HELPER -----------------------
class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  final List<Member> _members = [];
  final List<Payment> _payments = [];
  final List<Attendance> _attendance = [];

  int _nextMemberId = 1;
  int _nextPaymentId = 1;
  int _nextAttendanceId = 1;

  Future<int> insertMember(Member m) async {
    final newMember = Member(
      id: _nextMemberId++,
      name: m.name,
      phone: m.phone,
      email: m.email,
      plan: m.plan,
      joinedAt: m.joinedAt,
    );
    _members.add(newMember);
    return Future.value(newMember.id!);
  }

  Future<List<Member>> getAllMembers() async {
    return Future.value(List<Member>.from(_members)
      ..sort((a, b) => b.joinedAt.compareTo(a.joinedAt)));
  }

  Future<int> updateMember(Member m) async {
    final index = _members.indexWhere((member) => member.id == m.id);
    if (index != -1) {
      _members[index] = Member(
        id: m.id,
        name: m.name,
        phone: m.phone,
        email: m.email,
        plan: m.plan,
        joinedAt: m.joinedAt,
      );
      return Future.value(1);
    }
    return Future.value(0);
  }

  Future<int> deleteMember(int id) async {
    final initialLength = _members.length;
    _members.removeWhere((member) => member.id == id);
    _payments.removeWhere((payment) => payment.memberId == id);
    _attendance.removeWhere((attendance) => attendance.memberId == id);
    return Future.value(initialLength - _members.length);
  }

  Future<int> insertPayment(Payment p) async {
    final newPayment = Payment(
      id: _nextPaymentId++,
      memberId: p.memberId,
      amount: p.amount,
      paidAt: p.paidAt,
      note: p.note,
    );
    _payments.add(newPayment);
    return Future.value(newPayment.id!);
  }

  Future<List<Payment>> getPaymentsForMember(int memberId) async {
    return Future.value(_payments.where((p) => p.memberId == memberId).toList()
      ..sort((a, b) => b.paidAt.compareTo(a.paidAt)));
  }

  Future<int> insertAttendance(Attendance a) async {
    final newAttendance = Attendance(
      id: _nextAttendanceId++,
      memberId: a.memberId,
      time: a.time,
    );
    _attendance.add(newAttendance);
    return Future.value(newAttendance.id!);
  }

  Future<List<Attendance>> getAttendanceForMember(int memberId) async {
    return Future.value(_attendance.where((a) => a.memberId == memberId).toList()
      ..sort((a, b) => b.time.compareTo(a.time)));
  }
}

// ----------------------- APP -----------------------
class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management System',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue, // Changed to lightBlue
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
          backgroundColor: Colors.lightBlue, // Changed to lightBlue
          foregroundColor: Colors.white, // Ensure text is visible
        ),
        cardTheme: CardThemeData( // Changed from CardTheme to CardThemeData
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          surfaceTintColor: Colors.lightBlue.shade50,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.lightBlue.withOpacity(0.05),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------- MAIN SCREEN -----------------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final List<Widget> _pages = const [
    MembersPage(),
    RegisterPage(),
    FeesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym Management System')),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int i) => setState(() => _index = i),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.people), label: 'Members'),
          NavigationDestination(icon: Icon(Icons.person_add), label: 'Register'),
          NavigationDestination(icon: Icon(Icons.payment), label: 'Fees'),
        ],
      ),
    );
  }
}

// ----------------------- MEMBERS PAGE -----------------------
class MembersPage extends StatefulWidget {
  const MembersPage({super.key});
  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final DBHelper db = DBHelper.instance;
  late Future<List<Member>> _membersF;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _membersF = db.getAllMembers();
    });
  }

  Future<void> _deleteMember(int id) async {
    await db.deleteMember(id);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Member deleted')));
    }
  }

  Future<void> _markAttendance(Member m) async {
    if (m.id == null) return;
    await db.insertAttendance(Attendance(memberId: m.id!));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance recorded for ${m.name}')));
    }
  }

  Future<void> _openEdit(Member m) async {
    await Navigator.of(context)
        .push<void>(MaterialPageRoute<void>(builder: (_) => MemberForm(member: m)));
    _load();
  }

  Future<void> _openPayments(Member m) async {
    await Navigator.of(context)
        .push<void>(MaterialPageRoute<void>(builder: (_) => PaymentScreen(member: m)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: _membersF,
      builder: (BuildContext context, AsyncSnapshot<List<Member>> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<Member> members = snap.data ?? <Member>[];
        if (members.isEmpty) {
          return const Center(
              child: Text(
                  'No members yet — add new members from the Register tab.'));
        }
        return RefreshIndicator(
          onRefresh: () async => _load(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: members.length,
            itemBuilder: (BuildContext context, int i) {
              final Member m = members[i];
              return Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(m.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                  subtitle: Text(
                      '${m.plan} • Joined ${DateFormat.yMMMd().format(m.joinedAt)}'),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                          m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white))),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String v) async {
                      if (v == 'edit') {
                        await _openEdit(m);
                      } else if (v == 'delete' && m.id != null) {
                        await _deleteMember(m.id!);
                      } else if (v == 'attendance') {
                        await _markAttendance(m);
                      } else if (v == 'payments') {
                        await _openPayments(m);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: 'attendance', child: Text('Mark Attendance')),
                      PopupMenuItem<String>(
                          value: 'payments', child: Text('Payments')),
                      PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                      PopupMenuItem<String>(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ----------------------- REGISTER PAGE -----------------------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _plan = 'Monthly';
  final DBHelper db = DBHelper.instance;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final Member m = Member(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        plan: _plan);
    await db.insertMember(m);
    _name.clear();
    _phone.clear();
    _email.clear();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Member registered')));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Register New Member',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                          labelText: 'Full name', prefixIcon: Icon(Icons.person)),
                      validator: (String? v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                          labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (String? v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter phone' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _plan,
                      items: <String>['Monthly', 'Quarterly', 'Yearly']
                          .map<DropdownMenuItem<String>>((String p) =>
                              DropdownMenuItem<String>(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (String? v) => setState(() => _plan = v ?? 'Monthly'),
                      decoration:
                          const InputDecoration(labelText: 'Membership Plan'),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Register Member'),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------- FEES PAGE -----------------------
class FeesPage extends StatefulWidget {
  const FeesPage({super.key});
  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final DBHelper db = DBHelper.instance;
  late Future<List<Member>> _membersF;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _membersF = db.getAllMembers();
    });
  }

  void _openPayment(Member m) async {
    await Navigator.of(context)
        .push<void>(MaterialPageRoute<void>(builder: (_) => PaymentScreen(member: m)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: _membersF,
      builder: (BuildContext context, AsyncSnapshot<List<Member>> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<Member> members = snap.data ?? <Member>[];
        if (members.isEmpty) return const Center(child: Text('No members found.'));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: members.length,
          itemBuilder: (BuildContext context, int i) {
            final Member m = members[i];
            return Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white))),
                title: Text(m.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                subtitle: Text('Plan: ${m.plan}\nJoined: ${DateFormat.yMMMd().format(m.joinedAt)}'),
                isThreeLine: true,
                trailing: FilledButton(onPressed: () => _openPayment(m), child: const Text('Pay')),
              ),
            );
          },
        );
      },
    );
  }
}

// ----------------------- MEMBER FORM -----------------------
class MemberForm extends StatefulWidget {
  final Member? member;
  const MemberForm({this.member, super.key});
  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _email;
  String _plan = 'Monthly';
  final DBHelper db = DBHelper.instance;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.member?.name ?? '');
    _phone = TextEditingController(text: widget.member?.phone ?? '');
    _email = TextEditingController(text: widget.member?.email ?? '');
    _plan = widget.member?.plan ?? 'Monthly';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.member == null) {
      await db.insertMember(Member(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          plan: _plan));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Member added')));
      }
    } else {
      final Member updated = Member(
          id: widget.member!.id,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          plan: _plan,
          joinedAt: widget.member!.joinedAt);
      await db.updateMember(updated);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Member updated')));
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.member != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Member' : 'Add Member')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter phone' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _plan,
                    items: <String>['Monthly', 'Quarterly', 'Yearly']
                        .map<DropdownMenuItem<String>>((String p) => DropdownMenuItem<String>(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (String? v) => setState(() => _plan = v ?? 'Monthly'),
                    decoration: const InputDecoration(labelText: 'Plan'),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(isEditing ? 'Save changes' : 'Add member'),
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------- PAYMENT SCREEN -----------------------
class PaymentScreen extends StatefulWidget {
  final Member member;
  const PaymentScreen({required this.member, super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final DBHelper db = DBHelper.instance;
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  late Future<List<Payment>> _paymentsF;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      if (widget.member.id != null) {
        _paymentsF = db.getPaymentsForMember(widget.member.id!);
      } else {
        _paymentsF = Future<List<Payment>>.value(<Payment>[]);
      }
    });
  }

  Future<void> _addPayment() async {
    final String text = _amountCtrl.text.trim();
    if (text.isEmpty || widget.member.id == null) return;
    final double? amount = double.tryParse(text);
    if (amount == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      }
      return;
    }
    await db.insertPayment(Payment(
        memberId: widget.member.id!, amount: amount, note: _noteCtrl.text.trim()));
    _amountCtrl.clear();
    _noteCtrl.clear();
    _load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded')));
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments — ${widget.member.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(hintText: 'Amount (e.g. 1000)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _addPayment, child: const Text('Add')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(controller: _noteCtrl, decoration: const InputDecoration(hintText: 'Optional note')),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Payment>>(
                future: _paymentsF,
                builder: (BuildContext context, AsyncSnapshot<List<Payment>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Payment> payments = snap.data ?? <Payment>[];
                  if (payments.isEmpty) return const Center(child: Text('No payments yet'));
                  return ListView.separated(
                    itemCount: payments.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int i) {
                      final Payment pmt = payments[i];
                      return ListTile(
                        leading: const Icon(Icons.payments),
                        title: Text('₹${pmt.amount.toStringAsFixed(2)}'),
                        subtitle: Text('${DateFormat.yMMMd().add_jm().format(pmt.paidAt)}\n${pmt.note}'),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}