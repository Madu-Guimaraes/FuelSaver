import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? data;
  final double? valor;
  final double? km;
  final double? total;
  final IconData icon;
  final Color backgroundColor;

  const InfoCard({
    required this.title,
    this.data,
    this.valor,
    this.km,
    this.total,
    required this.icon,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (data != null || valor != null || total != null || km != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (data != null) //deixa o titulo em cima do valor
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Data:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              data!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.4),
                            )
                          ],
                        ),
                      if (valor != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Valor:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "R\$ ${valor!.toString()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.4),
                            )
                          ],
                        ),
                      if (km != null)
                        Text(
                          "${km!.toString()} KM",
                          style: const TextStyle(
                            color: Colors.white, fontSize: 14.4),
                        ),
                      if (total != null) 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "R\$ ${total!.toString()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.4),
                            )
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
