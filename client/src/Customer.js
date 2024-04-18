import { useState, useEffect } from 'react';
import { useParams } from "react-router-dom";
import QRCode from "react-qr-code";

export default function Customer(prop) {
  let { id } = useParams();
  const [customer, setCustomer] = useState({});

  useEffect(() => {
    fetch(`/api/customers/${id}`).then(async(r) => {
      const cus = await r.json();
      setCustomer(cus);
    });
  }, []);

  return (
    <>
      <h2>Customer</h2>
      <ul>
        <li>{id}</li>
        <li>{customer.name}</li>
        <QRCode value={id} />
      </ul>
    </>
  )
}
