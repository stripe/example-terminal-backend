import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

export default function Customers() {
  const API = process.env.TERMINAL_BACKEND_API
  const [customers, setCustomers] = useState([]);

  useEffect(() => {
    fetch(`/api/customers`).then(async(r) => {
      const { data } = await r.json();
      setCustomers(data);
    });
  }, []);

  return (
    <div>
      <h2>Customer2</h2>
      <ul>
        { customers.map((customer) => 
        <li><Link to={`/customers/${customer.id}`}>{customer.id}: {customer.name}</Link></li>
        )}
      </ul>
    </div>
  )
}
