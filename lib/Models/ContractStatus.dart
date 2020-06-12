import 'package:cloud_firestore/cloud_firestore.dart';

class ContractStatusContext {
  final String contract_id;
  final String status;
  final String process_status;
//  final String created_at;
  final String remark;
  String id;


  ContractStatusContext({
    this.contract_id,
    this.status,
//    this.created_at,
    this.process_status,
    this.remark,
    this.id,
  });

  factory ContractStatusContext.fromMap(Map<String, dynamic> data,
      String documentId) =>
      ContractStatusContext(
        contract_id: data["contract_id"],
        status: data["status"],
//        created_at: data["created_at"],
        process_status: data["process_status"],
        remark: data["remark"],
        id: data["id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "contract_id": contract_id,
        "status": status,
//        "created_at": created_at,
        "process_status": process_status,
        "remark": remark,
        "id": id,
      };

}